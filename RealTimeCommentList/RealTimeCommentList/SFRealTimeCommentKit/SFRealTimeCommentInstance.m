//
//  SFRealTimeCommentInstance.m
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/9.
//

#import "SFRealTimeCommentInstance.h"
#import <QuartzCore/QuartzCore.h>

NSString* const SFRealTimeCommentInstanceDefaultReuseID = @"SFRealTimeCommentInstanceDefaultReuseID";

@interface SFRealTimeCommentInstance()

@property(nonatomic, assign)BOOL startFlag;

@end

@implementation SFRealTimeCommentInstance

- (void)dealloc{
//    NSLog(@"SFRealTimeCommentInstance dealloc--");
    [self clear];
}

- (instancetype)initWithCommentData:(id)commentData{
    return [self initWithCommentData:commentData reuseIdentifier:SFRealTimeCommentInstanceDefaultReuseID];
}

- (instancetype)initWithCommentData:(id)commentData reuseIdentifier:(NSString*)reuseIdentifier{
    if(self = [super init]){
        self.commentData = commentData;
        self.requestStatus = YES;
        self.reuseIdentifier = reuseIdentifier;
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
}

- (void)continueDisplay{
}

- (void)clear{
    self.startFlag = NO;
    self.requestStatus = YES;
    _status = SFRealTimeCommentStatus_Clean;
}

- (void)setStatus:(SFRealTimeCommentStatus)status{
    if(_status == status){
        return ;
    }
    
    _status = status;
    
    if(SFRealTimeCommentStatus_Running == status){
        if(!self.startFlag){
            self.startFlag = YES;
            [self startDisplayComment];
        }else{
            [self continueDisplay];
        }
    }else if(SFRealTimeCommentStatus_Paused == status){
        [self pauseDisplay];
    }else if(SFRealTimeCommentStatus_Clean == status){
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

- (void)commentInstanceRunning:(CADisplayLink*)displayLink{
}

- (void)reDecorateCommentInstance{
    [self decorateCommentInstance];
}

@end
