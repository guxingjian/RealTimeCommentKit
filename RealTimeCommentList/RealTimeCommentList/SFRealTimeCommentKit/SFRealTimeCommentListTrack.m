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
    if(self.getCustomInstanceBlock){
        commentInstance = self.getCustomInstanceBlock(commentData);
    }else{
        commentInstance = [[SFRealTimeCommentInstance alloc] initWithCommentData:commentData];
    }
    return commentInstance;
}

- (void)showCommentData:(id)commentData{
    if(SFRealTimeCommentStatus_Stop == self.status){
        return ;
    }
    
    SFRealTimeCommentInstance* commentInstance = [self commentInstanceWithCommentData:commentData];
    [self.arrayCommentInstance addObject:commentInstance];
    
    commentInstance.commentContentView = self.commentContentView;
    commentInstance.commentSpeed = self.commentSpeed;
    commentInstance.commentDistance = self.commentDistance;
    commentInstance.trackBoundingRect = self.trackBoundingRect;
    commentInstance.commentInstanceDelegate = self;
    [commentInstance setStatus:self.status];
}

#pragma mark SFRealTimeCommentInstanceDelegate
- (void)realTimeCommentInstanceDidEndDisplay:(SFRealTimeCommentInstance *)commentInstance{
    [self.arrayCommentInstance removeObject:commentInstance];
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

@end
