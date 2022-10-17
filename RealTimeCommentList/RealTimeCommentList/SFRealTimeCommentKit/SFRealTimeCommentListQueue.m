//
//  SFRealTimeCommentListQueue.m
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/9.
//

#import "SFRealTimeCommentListQueue.h"

static NSInteger const SFRealTimeCommentListMaxSize = 50;

@interface SFRealTimeCommentListQueue()

@property(nonatomic, strong)NSMutableArray* arrayData;
@property(nonatomic, assign)NSInteger currentDataIndex;
@property(nonatomic, assign)NSInteger currentDataCount;
@property(nonatomic, strong)NSCondition* condition;
@property(nonatomic, strong)dispatch_queue_t addCommentQueue;
@property(nonatomic, strong)dispatch_queue_t getCommentQueue;
@property(nonatomic, assign)BOOL clearFlag;

@end

@implementation SFRealTimeCommentListQueue

- (void)dealloc{
//    NSLog(@"SFRealTimeCommentListQueue dealloc--");
}

- (instancetype)init{
    if(self = [super init]){
        _arrayData = [NSMutableArray array];
        _condition = [[NSCondition alloc] init];
        _addCommentQueue = dispatch_queue_create("SFRealTimeCommentAddCommentQueue", DISPATCH_QUEUE_SERIAL);
        _getCommentQueue = dispatch_queue_create("SFRealTimeCommentGetCommentQueue", DISPATCH_QUEUE_SERIAL);
        
        self.maxSize = 10000;
    }
    return self;
}

- (void)addCommentData:(id)commentData{
    NSMutableArray* arrayCurrentData = nil;
    if(0 == self.arrayData.count){
        arrayCurrentData = [NSMutableArray array];
        [self.arrayData addObject:arrayCurrentData];
    }else{
        arrayCurrentData = self.arrayData.lastObject;
        if(arrayCurrentData.count >= SFRealTimeCommentListMaxSize){
            arrayCurrentData = [NSMutableArray array];
            [self.arrayData addObject:arrayCurrentData];
        }
    }
    
    [arrayCurrentData addObject:commentData];
}

- (void)insertCommentData:(id)commentData{
    if(0 == self.arrayData.count){
        NSMutableArray* arrayCurrentData = [NSMutableArray arrayWithCapacity:SFRealTimeCommentListMaxSize];
        [self.arrayData addObject:arrayCurrentData];
        
        [arrayCurrentData addObject:commentData];
    }else{
        NSMutableArray* arrayCurrentData = self.arrayData.firstObject;
        if(self.currentDataIndex > 0){
            [arrayCurrentData replaceObjectAtIndex:(self.currentDataIndex - 1) withObject:commentData];
            self.currentDataIndex = self.currentDataIndex - 1;
        }else{
            NSMutableArray* arrayTemp = [NSMutableArray array];
            for(NSInteger i = 0; i < SFRealTimeCommentListMaxSize; ++ i){
                [arrayTemp addObject:commentData];
            }
            [self.arrayData insertObject:arrayTemp atIndex:0];
            self.currentDataIndex = SFRealTimeCommentListMaxSize - 1;
        }
    }
}

- (void)addRealTimeCommentsData:(NSArray*)arrayCommentData onTail:(BOOL)onTail{
    if(SFRealTimeCommentStatus_Clean == self.status){
        NSLog(@"can't add comment data, comment list queue current status is: %ld", self.status);
        return ;
    }
    
    NSArray* arrayTempData = [arrayCommentData copy];
    dispatch_async(self.addCommentQueue, ^{
        [self.condition lock];
        
        NSInteger addCount = 0;
        for(id commentData in arrayTempData){
            BOOL ret = YES;
            if(self.dealCommentBlock){
                ret = self.dealCommentBlock(commentData);
            }else{
                ret = [self dealCommentData:commentData];
            }
            if(!ret){
                continue;
            }
            
            if(onTail){
                [self addCommentData:commentData];
            }else{
                [self insertCommentData:commentData];
            }
            addCount = addCount + 1;
        }
        
        self.currentDataCount = self.currentDataCount + addCount;
        
        // 弹幕数量超出maxSize限制后，移除队首多余数据，保留最新数据
        if((self.maxSize > 0) && (self.currentDataCount > self.maxSize)){
            [self adjustDataCount];
        }
        
        [self.condition signal];
        [self.condition unlock];
    });
}

- (void)adjustDataCount{
    NSInteger removeCount = self.currentDataCount - self.maxSize;
    for(NSInteger i = 0; i < removeCount; ++ i){
        [self popLastCommentData];
    }
}

- (id)popLastCommentData{
    if(0 == self.arrayData.count){
        return nil;
    }
    
    NSArray* arrayCommentData = self.arrayData.firstObject;
    if(0 == arrayCommentData.count){
        return nil;
    }
    
    id commentData = nil;
    if(self.currentDataIndex < arrayCommentData.count){
        commentData = [arrayCommentData objectAtIndex:self.currentDataIndex];
        
        self.currentDataIndex = self.currentDataIndex + 1;
        if(self.currentDataIndex >= arrayCommentData.count){
            [self.arrayData removeObjectAtIndex:0];
            self.currentDataIndex = 0;
        }
        
        self.currentDataCount = self.currentDataCount - 1;
    }
    
    return commentData;
}

- (void)getRealTimeCommentDataWithCallBack:(SFRealTimeCommentListQueueCallBack)callBack{
    if(SFRealTimeCommentStatus_Clean == self.status){
        NSLog(@"can't get comment data, comment list queue current status is: %ld", self.status);
        return ;
    }
    
    dispatch_async(self.getCommentQueue, ^{
        [self.condition lock];
        
        // 添加clearFlag条件判断，防止弹幕系统销毁时，condition一直处于wait状态导致SFRealTimeCommentListQueue无法释放
        while (!self.clearFlag && (0 == self.currentDataCount)) {
            [self.condition wait];
        }
        
        id commentData = [self popLastCommentData];
         
        [self.condition unlock];
        
        if(callBack){
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(commentData);
            });
        }
    });
}

- (void)setCurrentDataCount:(NSInteger)currentDataCount{
    if(_currentDataCount == currentDataCount){
        return ;
    }
    
    _currentDataCount = currentDataCount;
    
    if(self.countChangedBlock){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.countChangedBlock(currentDataCount);
        });
    }
}

- (void)clear{
    dispatch_async(self.addCommentQueue, ^{
        [self.condition lock];
        
        [self commentListQueueClean];
        
        [self.condition broadcast];
        [self.condition unlock];
    });
}

- (void)commentListQueueClean{
    [self.arrayData removeAllObjects];
    
    self.currentDataIndex = 0;
    self.currentDataCount = 0;
    self.clearFlag = YES;
}

- (void)recover{
    dispatch_async(self.addCommentQueue, ^{
        [self.condition lock];
        
        [self commentListQueueRunning];
        
        [self.condition unlock];
    });
}

- (void)commentListQueueRunning{
    self.clearFlag = NO;
}

- (BOOL)dealCommentData:(id)commentData{
    return YES;
}

- (void)setStatus:(SFRealTimeCommentStatus)status{
    if(_status == status){
        return ;
    }
    
    _status = status;
    
    if(SFRealTimeCommentStatus_Running == status){
        [self recover];
    }else if(SFRealTimeCommentStatus_Clean == status){
        [self clear];
    }
}

@end
