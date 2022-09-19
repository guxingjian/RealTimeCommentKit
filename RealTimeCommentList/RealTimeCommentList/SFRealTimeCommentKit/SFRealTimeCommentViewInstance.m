//
//  SFRealTimeCommentViewInstance.m
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/19.
//

#import "SFRealTimeCommentViewInstance.h"

@interface SFRealTimeCommentViewInstance()

@property(nonatomic, readwrite)UIView* commentView;
@property(nonatomic, strong)CADisplayLink* displayLink;

@end

@implementation SFRealTimeCommentViewInstance

- (void)decorateCommentInstance{
    [super decorateCommentInstance];
    
    CGFloat posY = self.trackBoundingRect.origin.y + (self.trackBoundingRect.size.height - self.commentView.frame.size.height)/2;
    self.commentView.frame = CGRectMake(self.commentContentView.bounds.size.width, posY, self.commentView.bounds.size.width, self.commentView.bounds.size.height);
}

- (void)startDisplayComment{
    UIView* view = [[UIView alloc] initWithFrame:CGRectZero];
    
    if(self.canRespondsTouchEvent){
        UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [view addGestureRecognizer:tapGes];
    }
    
    self.commentView = view;
    [self.commentContentView addSubview:self.commentView];
    
    [super startDisplayComment];
    
    [self startRunning];
}

- (void)stopDisplayLink{
    if(self.displayLink){
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)startRunning{
    [self stopDisplayLink];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(commentInstanceRunning)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)pauseDisplay{
    [super pauseDisplay];
    
    [self stopDisplayLink];
}

- (void)continueDisplay{
    [super continueDisplay];
    
    [self startRunning];
}

- (BOOL)canRespondsTouchEvent{
    return YES;
}

- (void)tapGestureAction:(UITapGestureRecognizer*)tapGes{
    [self sendTouchEvent];
}

- (void)commentInstanceRunning{
    CGFloat speed = self.commentSpeed;
    CGRect frame = self.commentView.frame;
    frame.origin.x = frame.origin.x - self.displayLink.duration * speed;
    self.commentView.frame = frame;
    
    if(frame.origin.x <= -frame.size.width){
        [self stopDisplayLink];
        [self comnentInstanceDisplayEnded];
    }
}

- (CGRect)currentBoundingRect{
    return self.commentView.frame;
}

- (void)clear{
    [super clear];
    
    [self stopDisplayLink];
    [self.commentView removeFromSuperview];
    self.commentView = nil;
}

@end
