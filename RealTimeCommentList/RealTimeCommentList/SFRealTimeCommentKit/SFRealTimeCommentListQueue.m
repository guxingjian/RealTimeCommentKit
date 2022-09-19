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
        NSMutableArray* arrayCurrentData = [NSMutableArray array];
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
    NSArray* arrayTempData = [arrayCommentData copy];
    dispatch_async(self.addCommentQueue, ^{
        [self.condition lock];
        
        for(id commentData in arrayTempData){
            if(onTail){
                [self addCommentData:commentData];
            }else{
                [self insertCommentData:commentData];
            }
        }
        
        self.currentDataCount = self.currentDataCount + arrayCommentData.count;
        
        [self.condition signal];
        [self.condition unlock];
    });
}

- (id)getLastCommentData{
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
    dispatch_async(self.getCommentQueue, ^{
        [self.condition lock];
        
        while (0 == self.currentDataCount) {
            [self.condition wait];
        }
        
        id commentData = [self getLastCommentData];
        
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
        
        [self.arrayData removeAllObjects];
        
        self.currentDataIndex = 0;
        self.currentDataCount = 0;
        
        [self.condition signal];
        [self.condition unlock];
    });
}

@end
