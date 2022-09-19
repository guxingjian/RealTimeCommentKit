//
//  SFRealTimeCommentInstance.m
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/9.
//

#import "SFRealTimeCommentInstance.h"
#import <QuartzCore/QuartzCore.h>

@interface SFRealTimeCommentInstance()

@property(nonatomic, assign)BOOL dispalying;

@end

@implementation SFRealTimeCommentInstance

- (void)dealloc{
//    NSLog(@"SFRealTimeCommentInstance dealloc--");
}

- (instancetype)initWithCommentData:(id)commentData{
    if(self = [super init]){
        self.commentData = commentData;
        self.requestStatus = YES;
    }
    return self;
}

- (void)triggerRequestNextCommentData{
    self.requestStatus = NO;
    
    if([self.commentInstanceDelegate respondsToSelector:@selector(realTimeCommentInstanceRequestNextCommentData:)]){
        [self.commentInstanceDelegate realTimeCommentInstanceRequestNextCommentData:self];
    }
}

- (void)pauseDisplay{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)continueDisplay{
}

- (void)clear{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)resetRequestNextCommentDataTimer{
    CGRect currentBoundingRect = [self currentBoundingRect];
    if(CGRectEqualToRect(currentBoundingRect, CGRectZero)){
        return ;
    }
    
    CGFloat posX = self.commentContentView.bounds.size.width - self.commentDistance - currentBoundingRect.size.width;
    if(currentBoundingRect.origin.x <= posX){
        [self triggerRequestNextCommentData];
        return ;
    }
    
    CGFloat speed = self.commentSpeed;
    CGFloat requestInterval = ((currentBoundingRect.origin.x + currentBoundingRect.size.width) - posX)/speed;
    [self performSelector:@selector(triggerRequestNextCommentData) withObject:nil afterDelay:requestInterval inModes:@[NSRunLoopCommonModes]];
}

- (void)setStatus:(SFRealTimeCommentStatus)status{
    if(_status == status){
        return ;
    }
    
    _status = status;
    
    if(SFRealTimeCommentStatus_Running == status){
        if(!self.dispalying){
            self.dispalying = YES;
            [self startDisplayComment];
        }else{
            [self continueDisplay];
        }
        if(self.requestStatus){
            [self resetRequestNextCommentDataTimer];
        }
    }else if(SFRealTimeCommentStatus_Paused == status){
        [self pauseDisplay];
    }else if(SFRealTimeCommentStatus_Stop == status){
        [self clear];
    }
}

- (void)startDisplayComment{
    [self decorateCommentInstance];
}

- (void)decorateCommentInstance{
    
}

- (CGRect)currentBoundingRect{
    return CGRectZero;
}

- (void)comnentInstanceDisplayEnded{
    [self clear];
    if([self.commentInstanceDelegate respondsToSelector:@selector(realTimeCommentInstanceDidEndDisplay:)]){
        [self.commentInstanceDelegate realTimeCommentInstanceDidEndDisplay:self];
    }
}

- (BOOL)canRespondsTouchEvent{
    return NO;
}

- (void)sendTouchEvent{
    if([self.commentInstanceDelegate respondsToSelector:@selector(realTimeCommentInstanceDidSelected:)]){
        [self.commentInstanceDelegate realTimeCommentInstanceDidSelected:self];
    }
}

- (CGFloat)commentSpeed{
    if(0 == _commentSpeed){
        return 80;
    }
    return _commentSpeed;
}

@end
