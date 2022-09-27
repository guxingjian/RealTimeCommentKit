//
//  SFRealTimeCommentListTrack.m
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/9.
//

#import "SFRealTimeCommentListTrack.h"

@interface SFRealTimeCommentListTrack()

@property(nonatomic, strong)NSMutableArray* arrayCommentInstance;
@property(nonatomic, assign)NSTimeInterval nextRequestTimeStamp;
@property(nonatomic, assign)BOOL asyncRequestStatus;

@end

@implementation SFRealTimeCommentListTrack

- (void)dealloc{
//    NSLog(@"SFRealTimeCommentListTrack dealloc--");
}

- (instancetype)init{
    if(self = [super init]){
        _arrayCommentInstance = [NSMutableArray array];
        _activeStatus = YES;
    }
    return self;
}

- (SFRealTimeCommentInstance*)commentInstanceWithCommentData:(id)commentData{
    SFRealTimeCommentInstance* commentInstance = nil;
    if([self.trackDelegate respondsToSelector:@selector(commentTrack:requestNewCommentInstanceWithData:)]){
        commentInstance = [self.trackDelegate commentTrack:self requestNewCommentInstanceWithData:commentData];
    }
    return commentInstance;
}

- (void)showCommentData:(id)commentData{
    if(SFRealTimeCommentStatus_Stop == self.status){
        return ;
    }
    
    SFRealTimeCommentInstance* commentInstance = [self commentInstanceWithCommentData:commentData];
    if(!commentInstance){
        __weak SFRealTimeCommentListTrack* weakTrack = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakTrack requestCommentData];
        });
        return ;
    }
    
    [self.arrayCommentInstance addObject:commentInstance];
    if([self.trackDelegate respondsToSelector:@selector(commentTrack:didAddCommentInstance:)]){
        [self.trackDelegate commentTrack:self didAddCommentInstance:commentInstance];
    }
    
    commentInstance.commentContentView = self.commentContentView;
    commentInstance.commentSpeed = self.commentSpeed;
    commentInstance.commentDistance = self.commentDistance;
    commentInstance.trackBoundingRect = self.trackBoundingRect;
    commentInstance.commentInstanceDelegate = self;
    [commentInstance setStatus:self.status];
}

#pragma mark SFRealTimeCommentInstanceDelegate
- (void)realTimeCommentInstanceDidEndDisplay:(SFRealTimeCommentInstance *)commentInstance{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self realRemove:commentInstance];
    });
}

- (void)realTimeCommentInstanceRequestNextCommentData:(SFRealTimeCommentInstance *)commentInstance{
    [self requestCommentData];
}

- (void)requestCommentData{
    if(!self.activeStatus){
        return ;
    }
    
    if(self.arrayCommentInstance.count > 0){
        SFRealTimeCommentInstance* instance = self.arrayCommentInstance.lastObject;
        if(instance.requestStatus){
            return ;
        }
    }
    
    if(self.asyncRequestStatus){
        return ;
    }
    
    __weak SFRealTimeCommentListTrack* track = self;
    self.asyncRequestStatus = YES;
    [self.commentListQueue getRealTimeCommentDataWithCallBack:^(id  _Nonnull commentData) {
        track.asyncRequestStatus = NO;
        [track showCommentData:commentData];
    }];
}

- (void)setActiveStatus:(BOOL)activeStatus{
    if(_activeStatus == activeStatus){
        return ;
    }
    
    _activeStatus = activeStatus;
    
    if(activeStatus){
        [self requestCommentData];
    }
}

- (void)setTrackBoundingRect:(CGRect)trackBoundingRect{
    if(CGRectEqualToRect(_trackBoundingRect, trackBoundingRect)){
        return ;
    }
    
    _trackBoundingRect = trackBoundingRect;
    
    for(SFRealTimeCommentInstance* commentInstance in self.arrayCommentInstance){
        commentInstance.trackBoundingRect = trackBoundingRect;
    }
}

- (void)setStatus:(SFRealTimeCommentStatus)status{
    if(_status == status){
        return ;
    }
    
    if(SFRealTimeCommentStatus_Running == status){
        [self requestCommentData];
    }
    
    for(SFRealTimeCommentInstance* commentInstance in self.arrayCommentInstance){
        commentInstance.status = status;
    }
    
    _status = status;
    
    if(SFRealTimeCommentStatus_Stop == status){
        [self.arrayCommentInstance removeAllObjects];
    }
}

- (SFRealTimeCommentInstance*)getTapInstanceWithHitPoint:(CGPoint)point{
    for(SFRealTimeCommentInstance* instance in self.arrayCommentInstance){
        CGRect commentRect = [instance currentBoundingRect];
        if(CGRectContainsPoint(commentRect, point)){
            return instance;
        }
    }
    
    return nil;
}

- (void)realTimeCommentInstanceDidSelected:(SFRealTimeCommentInstance *)commentInstance{
    if(self.selectInstanceBlock){
        self.selectInstanceBlock(commentInstance);
    }
}

- (BOOL)commentInstanceRunning:(CADisplayLink*)displayLink{
    BOOL bRet = NO;
    for(SFRealTimeCommentInstance* instance in self.arrayCommentInstance){
        [instance commentInstanceRunning:displayLink];
        bRet = YES;
    }
    return bRet;
}

- (SFRealTimeCommentInstance*)searchCommentInstanceWithBlock:(SFRealTimeCommentSearchInstanceBlock)searchBlock{
    for(SFRealTimeCommentInstance* instance in self.arrayCommentInstance){
        if(searchBlock && searchBlock(instance)){
            return instance;
        }
    }
    return nil;
}

- (void)removeCommentInstance:(SFRealTimeCommentInstance*)commentInstance{
    if((0 == self.arrayCommentInstance.count) || ![self.arrayCommentInstance containsObject:commentInstance]){
        return ;
    }
    
    BOOL shouldRequestNextComment = (commentInstance == self.arrayCommentInstance.lastObject);
    
    [commentInstance clear];
    
    [self realRemove:commentInstance];
    
    if(shouldRequestNextComment){
        [self requestCommentData];
    }
}

- (void)realRemove:(SFRealTimeCommentInstance*)commentInstance{
    [self.arrayCommentInstance removeObject:commentInstance];
    
    if([self.trackDelegate respondsToSelector:@selector(commentTrack:didEndDisplayCommentInstance:)]){
        [self.trackDelegate commentTrack:self didEndDisplayCommentInstance:commentInstance];
    }
}

- (NSInteger)commentInstanceCount{
    return self.arrayCommentInstance.count;
}

@end
