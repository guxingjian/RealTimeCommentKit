//
//  SFRealTimeCommentContentView.m
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/9.
//

#import "SFRealTimeCommentContentView.h"

@interface SFRealTimeCommentContentView()

@property(nonatomic, strong)NSMutableArray* arrayCommentTrack;
@property(nonatomic, assign)BOOL disableSelectCommentInstance;

//@property(nonatomic, assign)SFRealTimeCommentStatus cacheStatus;
@property(nonatomic, strong)NSMutableDictionary* dicCommentInstanceReusePool;

@property(nonatomic, strong)CADisplayLink* displayLink;

@property(nonatomic, assign)CGFloat cacheTime;

@end

@implementation SFRealTimeCommentContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc{
//    NSLog(@"SFRealTimeCommentContentView dealloc--");
}

- (NSMutableArray *)arrayCommentTrack{
    if(!_arrayCommentTrack){
        _arrayCommentTrack = [NSMutableArray array];
    }
    return _arrayCommentTrack;
}

- (SFRealTimeCommentListTrack*)createCommentListTrackWithIndex:(NSInteger)trackIndex{
    SFRealTimeCommentListTrack* track = nil;
    if(self.getCustomTrackBlock){
        track = self.getCustomTrackBlock(trackIndex);
    }else{
        track = [[SFRealTimeCommentListTrack alloc] init];
        track.trackBoundingRect = CGRectMake(0, 30 + 100*trackIndex, self.bounds.size.width, 50);
        track.commentSpeed = 80;
        track.commentDistance = 100;
    }
    
    track.commentContentView = self;
    track.commentListQueue = self.commentListQueue;
    track.trackIndex = trackIndex;
    track.trackDelegate = self;
    
    __weak SFRealTimeCommentContentView* contentView = self;
    track.selectInstanceBlock = ^(SFRealTimeCommentInstance * _Nonnull commentInstance) {
        [contentView selectedCommentInstance:commentInstance];
    };
    
    return track;
}

- (void)setTrackCount:(NSInteger)trackCount{
    if(_trackCount == trackCount){
        return ;
    }
    
    for(NSInteger i = self.arrayCommentTrack.count; i < trackCount; ++ i){
        SFRealTimeCommentListTrack* commentTrack = [self createCommentListTrackWithIndex:i];
        commentTrack.commentListQueue = self.commentListQueue;
        [self.arrayCommentTrack addObject:commentTrack];
        
        commentTrack.status = self.status;
    }
    
    BOOL activeStatus = YES;
    NSInteger startIndex = _trackCount;
    NSInteger endIndex = trackCount;
    if(trackCount < _trackCount){
        startIndex = trackCount;
        endIndex = _trackCount;
        
        activeStatus = NO;
    }
    
    for(NSInteger i = startIndex; i < endIndex; ++ i){
        SFRealTimeCommentListTrack* track = [self.arrayCommentTrack objectAtIndex:i];
        track.activeStatus = activeStatus;
    }
    
    _trackCount = trackCount;
}

- (void)setCommentListQueue:(SFRealTimeCommentListQueue *)commentListQueue{
    _commentListQueue = commentListQueue;
    
    for(SFRealTimeCommentListTrack* track in self.arrayCommentTrack){
        track.commentListQueue = commentListQueue;
    }
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    for(SFRealTimeCommentListTrack* track in self.arrayCommentTrack){
        CGRect boundingRect = track.trackBoundingRect;
        track.trackBoundingRect = CGRectMake(0, boundingRect.origin.y, self.bounds.size.width, boundingRect.size.height);
    }
}

- (void)setStatus:(SFRealTimeCommentStatus)status{
    if(_status == status){
        return ;
    }
    
    _status = status;
    
    if(!self.useCoreAnimation){
        if(SFRealTimeCommentStatus_Running == status){
            [self startDisplayLink];
        }else{
            [self stopDisplayLink];
        }
    }
    
    for(SFRealTimeCommentListTrack* track in self.arrayCommentTrack){
        track.status = status;
    }
    
    if(SFRealTimeCommentStatus_Clean == status){
        [self.dicCommentInstanceReusePool removeAllObjects];
    }
}

- (SFRealTimeCommentInstance*)getSelectedCommentInstanceWithPoint:(CGPoint)point{
    SFRealTimeCommentInstance* commentInstance = nil;
    for(SFRealTimeCommentListTrack* track in self.arrayCommentTrack){
        commentInstance = [track getTapInstanceWithHitPoint:point];
        if(commentInstance){
            break ;
        }
    }
    return commentInstance;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if(self.hidden){
        return nil;
    }
    
    SFRealTimeCommentInstance* commentInstance = [self getSelectedCommentInstanceWithPoint:point];
    if(!commentInstance){
        return nil;
    }
    
    if(![commentInstance canRespondsTouchEvent]){
        __weak SFRealTimeCommentContentView* contentView = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [contentView triggerSelecteCommentInstance:commentInstance];
        });
        
        return self;
    }
    
    return [super hitTest:point withEvent:event];
}

- (void)selectedCommentInstance:(SFRealTimeCommentInstance*)commentInstance{
    if(self.disableSelectCommentInstance){
        return ;
    }
    
    self.disableSelectCommentInstance = YES;
    __weak SFRealTimeCommentContentView* contentView = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        contentView.disableSelectCommentInstance = NO;
    });
    
    if(self.tapInstanceBlock){
        self.tapInstanceBlock(commentInstance);
    }
}

- (void)triggerSelecteCommentInstance:(SFRealTimeCommentInstance*)commentInstance{
    if([NSRunLoop currentRunLoop].currentMode == UITrackingRunLoopMode){
        return ;
    }
    
    [self selectedCommentInstance:commentInstance];
}

//- (void)willMoveToWindow:(UIWindow *)newWindow{
//    [super willMoveToWindow:newWindow];
//
//    if(newWindow && (SFRealTimeCommentStatus_Running == self.cacheStatus)){
//        self.cacheStatus = SFRealTimeCommentStatus_Unknown;
//        self.status = SFRealTimeCommentStatus_Running;
//    }else if(!newWindow && (SFRealTimeCommentStatus_Running == self.status)){
//        self.cacheStatus = self.status;
//        self.status = SFRealTimeCommentStatus_Paused;
//    }
//}

- (NSMutableDictionary *)dicCommentInstanceReusePool{
    if(!_dicCommentInstanceReusePool){
        _dicCommentInstanceReusePool = [NSMutableDictionary dictionary];
    }
    return _dicCommentInstanceReusePool;
}

- (SFRealTimeCommentInstance*)reuseCommentInstanceWithIdentifier:(NSString*)identifier commentData:(id)commentData{
    NSMutableArray* arrayCommentInstance = [self.dicCommentInstanceReusePool objectForKey:identifier];
    if(!arrayCommentInstance){
        arrayCommentInstance = [NSMutableArray array];
        [self.dicCommentInstanceReusePool setObject:arrayCommentInstance forKey:identifier];
    }
    
    SFRealTimeCommentInstance* commentInstance = nil;
    if(arrayCommentInstance.count > 0){
        commentInstance = arrayCommentInstance.lastObject;
        commentInstance.commentData = commentData;
        commentInstance.requestStatus = YES;
        [arrayCommentInstance removeLastObject];
    }
    return commentInstance;
}

- (SFRealTimeCommentInstance *)commentTrack:(SFRealTimeCommentListTrack *)track requestNewCommentInstanceWithData:(id)commentData{
    SFRealTimeCommentInstance* commentInstance = nil;
    if(self.getCustomInstanceBlock){
        commentInstance = self.getCustomInstanceBlock(commentData);
    }else{
        commentInstance = [self reuseCommentInstanceWithIdentifier:SFRealTimeCommentInstanceDefaultReuseID commentData:commentData];
        if(!commentInstance){
            commentInstance = [[SFRealTimeCommentInstance alloc] initWithCommentData:commentData];
        }
    }
    
    return commentInstance;
}

- (void)commentTrack:(SFRealTimeCommentListTrack *)track didEndDisplayCommentInstance:(SFRealTimeCommentInstance *)commentInstance{
    NSString* identifier = commentInstance.reuseIdentifier;
    if(0 == identifier.length){
        return ;
    }
    
    NSMutableArray* arrayCommentInstance = [self.dicCommentInstanceReusePool objectForKey:identifier];
    if(!arrayCommentInstance){
        arrayCommentInstance = [NSMutableArray array];
        [self.dicCommentInstanceReusePool setObject:arrayCommentInstance forKey:identifier];
    }
    
    [arrayCommentInstance addObject:commentInstance];
    
    [self updateCurrentDispalyingRect];
}

- (void)commentTrack:(SFRealTimeCommentListTrack *)track didAddCommentInstance:(SFRealTimeCommentInstance *)commentInstance{
    if(!self.useCoreAnimation && !self.displayLink){
        [self startDisplayLink];
    }
    
    [self updateCurrentDispalyingRect];
}

- (NSInteger)totalCommentInstanceCount{
    NSInteger totalCount = 0;
    for(SFRealTimeCommentListTrack* track in self.arrayCommentTrack){
        totalCount = totalCount + [track commentInstanceCount];
    }
    return totalCount;
}

- (void)startDisplayLink{
    [self stopDisplayLink];
    
    NSInteger commentInstanceCount = [self totalCommentInstanceCount];
    if(0 == commentInstanceCount){
        return ;
    }
    if(self.status != SFRealTimeCommentStatus_Running){
        return ;
    }
    self.cacheTime = [NSDate timeIntervalSinceReferenceDate];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(commentInstanceRunning)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopDisplayLink{
    if(self.displayLink){
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)commentInstanceRunning{
    CGFloat nowTime = [NSDate timeIntervalSinceReferenceDate];
    CGFloat interval = nowTime - self.cacheTime;
    
    BOOL bFlag = NO;
    for(SFRealTimeCommentListTrack* track in self.arrayCommentTrack){
        BOOL bRet = [track commentInstanceRunning:interval];
        bFlag = bFlag || bRet;
    }
    if(!bFlag){
        [self stopDisplayLink];
    }
    
    self.cacheTime = nowTime;
}

- (SFRealTimeCommentInstance*)searchCommentInstanceWithBlock:(SFRealTimeCommentSearchInstanceBlock)searchBlock{
    for(SFRealTimeCommentListTrack* track in self.arrayCommentTrack){
        SFRealTimeCommentInstance* instance = [track searchCommentInstanceWithBlock:searchBlock];
        if(instance){
            return instance;
        }
    }
    return nil;
}

- (void)removeCommentInstance:(SFRealTimeCommentInstance*)commentInstance{
    for(SFRealTimeCommentListTrack* track in self.arrayCommentTrack){
        [track removeCommentInstance:commentInstance];
    }
}

- (SFRealTimeCommentListTrack*)trackAtIndex:(NSInteger)index{
    if(index < self.arrayCommentTrack.count){
        return [self.arrayCommentTrack objectAtIndex:index];
    }
    return nil;
}

- (void)updateCurrentDispalyingRect{
    CGFloat topPosY = self.bounds.size.height;
    CGFloat bottomPosY = 0;
    for(SFRealTimeCommentListTrack* track in self.arrayCommentTrack){
        if([track commentInstanceCount] > 0){
            CGRect trackBoundingRect = track.trackBoundingRect;
            if(trackBoundingRect.origin.y < topPosY){
                topPosY = trackBoundingRect.origin.y;
            }
            if((trackBoundingRect.origin.y + trackBoundingRect.size.height) > bottomPosY){
                bottomPosY = (trackBoundingRect.origin.y + trackBoundingRect.size.height);
            }
        }
    }
    
    if(bottomPosY > topPosY){
        self.currentDisplayingRect = CGRectMake(0, topPosY, self.bounds.size.width, bottomPosY - topPosY);
    }
}

@end
