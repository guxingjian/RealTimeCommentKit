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

- (void)decorateCommentInstance{
    [super decorateCommentInstance];
    
    CGFloat posY = self.trackBoundingRect.origin.y + (self.trackBoundingRect.size.height - self.commentLayer.frame.size.height)/2;
    self.commentLayer.position = CGPointMake(self.commentContentView.bounds.size.width, posY);
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
    animation.duration = (self.commentContentView.bounds.size.width + commentLayer.frame.size.width)/speed;
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
    
    if(0 == self.commentLayer.speed){
        return ;
    }
    
    CFTimeInterval pausedTime = [self.commentLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.commentLayer.speed = 0;
    self.commentLayer.timeOffset = pausedTime;
}

- (void)continueDisplay{
    [super continueDisplay];
    
    if(1 == self.commentLayer.speed){
        return ;
    }
    
    self.commentLayer.speed = 1;
    self.commentLayer.beginTime = 0;
    CFTimeInterval pausedTime = self.commentLayer.timeOffset;
    self.commentLayer.timeOffset = 0;
    self.commentLayer.beginTime = [self.commentLayer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
}

- (void)clear{
    [super clear];
    
    [self.commentLayer removeAllAnimations];
    [self.commentLayer removeFromSuperlayer];
    self.commentLayer = nil;
}

- (void)startDisplayComment{
    CALayer* layer = [CALayer layer];
    layer.anchorPoint = CGPointZero;
    self.commentLayer = layer;
    [self.commentContentView.layer addSublayer:self.commentLayer];
    
    [super startDisplayComment];
    
    [self addCommentDisplayAnimation];
}

- (BOOL)canRespondsTouchEvent{
    return NO;
}

@end
