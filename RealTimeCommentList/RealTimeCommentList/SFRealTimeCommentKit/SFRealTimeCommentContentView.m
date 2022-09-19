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

@property(nonatomic, assign)SFRealTimeCommentStatus cacheStatus;

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
    if(self.getCustomInstanceBlock){
        track.getCustomInstanceBlock = self.getCustomInstanceBlock;
    }
    
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
    
    for(SFRealTimeCommentListTrack* track in self.arrayCommentTrack){
        track.status = status;
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

- (void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow:newWindow];
    
    if(newWindow && (SFRealTimeCommentStatus_Running == self.cacheStatus)){
        self.cacheStatus = SFRealTimeCommentStatus_Unknown;
        self.status = SFRealTimeCommentStatus_Running;
    }else if(!newWindow && (SFRealTimeCommentStatus_Running == self.status)){
        self.cacheStatus = self.status;
        self.status = SFRealTimeCommentStatus_Paused;
    }
}

@end
