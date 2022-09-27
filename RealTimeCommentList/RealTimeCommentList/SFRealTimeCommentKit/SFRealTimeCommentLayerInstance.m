//
//  SFRealTimeCommentLayerInstance.m
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/16.
//

#import "SFRealTimeCommentLayerInstance.h"

@interface SFRealTimeCommentLayerInstance()

@property(nonatomic, readwrite)CALayer* commentLayer;

@end

@implementation SFRealTimeCommentLayerInstance

- (void)dealloc{
    [self clear];
}

- (CALayer *)commentLayer{
    if(!_commentLayer){
        CALayer* layer = [CALayer layer];
        layer.anchorPoint = CGPointZero;
        _commentLayer = layer;
    }
    return _commentLayer;
}

- (void)decorateCommentInstance{
    [super decorateCommentInstance];
    
    CGFloat posY = self.trackBoundingRect.origin.y + (self.trackBoundingRect.size.height - self.commentLayer.frame.size.height)/2;
    self.commentLayer.position = CGPointMake(self.commentContentView.bounds.size.width, posY);
    if(!self.commentLayer.superlayer){
        [self.commentContentView.layer addSublayer:self.commentLayer];
    }
}

- (void)addCommentDisplayAnimation{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"position"];

    CALayer* commentLayer = self.commentLayer;
    animation.fromValue = [NSValue valueWithCGPoint:self.commentLayer.frame.origin];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(-self.commentLayer.bounds.size.width, self.commentLayer.frame.origin.y)];
    
    animation.delegate = self;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    CGFloat speed = self.commentSpeed;
    animation.duration = (commentLayer.frame.origin.x + commentLayer.frame.size.width)/speed;
    [commentLayer addAnimation:animation forKey:@"position"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if(flag){
        [self comnentInstanceDisplayEnded];
    }
}

- (CGRect)currentBoundingRect{
    CALayer* tempLayer = self.commentLayer.presentationLayer;
    if(!tempLayer){
        tempLayer = self.commentLayer;
    }
    
    return tempLayer.frame;
}

- (void)pauseDisplay{
    [super pauseDisplay];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
  
    CGRect frame = [self currentBoundingRect];
    
    [self.commentLayer removeAllAnimations];
    self.commentLayer.frame = frame;
    
//    if(0 == self.commentLayer.speed){
//        return ;
//    }
//
//    CFTimeInterval pausedTime = [self.commentLayer convertTime:CACurrentMediaTime() fromLayer:nil];
//    self.commentLayer.speed = 0;
//    self.commentLayer.timeOffset = pausedTime;
}

- (void)continueDisplay{
    [super continueDisplay];
    
    [self addCommentDisplayAnimation];
    
//    if(1 == self.commentLayer.speed){
//        return ;
//    }
//
//    self.commentLayer.speed = 1;
//    self.commentLayer.beginTime = 0;
//    CFTimeInterval pausedTime = self.commentLayer.timeOffset;
//    self.commentLayer.timeOffset = 0;
//    self.commentLayer.beginTime = [self.commentLayer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
}

- (void)clear{
    [super clear];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [_commentLayer removeAllAnimations];
    [_commentLayer removeFromSuperlayer];
}

- (void)startDisplayComment{
    [super startDisplayComment];
    
    [self addCommentDisplayAnimation];
}

- (void)setStatus:(SFRealTimeCommentStatus)status{
    [super setStatus:status];
    
    if(SFRealTimeCommentStatus_Running == status){
        if(self.requestStatus){
            [self resetRequestNextCommentDataTimer];
        }
    }
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

@end
