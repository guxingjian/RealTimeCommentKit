//
//  SFRealTimeCommentViewInstance.m
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/19.
//

#import "SFRealTimeCommentViewInstance.h"

@interface SFRealTimeCommentViewInstance()

@property(nonatomic, readwrite)UIView* commentView;

@property(nonatomic, assign)CGFloat requestTargetPosX;

@end

@implementation SFRealTimeCommentViewInstance

- (void)dealloc{
    [_commentView removeFromSuperview];
}

- (UIView *)commentView{
    if(!_commentView){
        UIView* view = [[UIView alloc] initWithFrame:CGRectZero];
        _commentView = view;
    }
    return _commentView;
}

- (void)decorateCommentInstance{
    [super decorateCommentInstance];
    
    CGFloat posY = self.trackBoundingRect.origin.y + (self.trackBoundingRect.size.height - self.commentView.frame.size.height)/2;
    self.commentView.frame = CGRectMake(self.commentContentView.bounds.size.width, posY, self.commentView.bounds.size.width, self.commentView.bounds.size.height);
    if(!self.commentView.superview){
        [self.commentContentView addSubview:self.commentView];
    }
    
    self.requestTargetPosX = self.commentContentView.bounds.size.width - self.commentDistance - self.commentView.bounds.size.width;
}

- (BOOL)canRespondsTouchEvent{
    return YES;
}

- (CGRect)currentBoundingRect{
    return self.commentView.frame;
}

- (void)clear{
    [super clear];
    
    [_commentView removeFromSuperview];
}

- (void)commentInstanceRunning:(CADisplayLink*)displayLink{
    CGRect frame = self.commentView.frame;
    frame.origin.x = frame.origin.x - displayLink.duration * self.commentSpeed;
    [self.commentView setFrame:frame];
    
    if((frame.origin.x <= self.requestTargetPosX) && self.requestStatus){
        [self triggerRequestNextCommentData];
    }
    
    if(frame.origin.x <= -frame.size.width){
        [self comnentInstanceDisplayEnded];
    }
}

@end
