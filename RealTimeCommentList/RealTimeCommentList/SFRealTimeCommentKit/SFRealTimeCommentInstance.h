//
//  SFRealTimeCommentInstance.h
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/9.
//

#import <UIKit/UIKit.h>
#import "SFRealtimeCommentHeader.h"

NS_ASSUME_NONNULL_BEGIN

@class SFRealTimeCommentInstance;

@protocol SFRealTimeCommentInstanceDelegate <NSObject>

- (void)realTimeCommentInstanceRequestNextCommentData:(SFRealTimeCommentInstance*)commentInstance;
- (void)realTimeCommentInstanceDidEndDisplay:(SFRealTimeCommentInstance*)commentInstance;
- (void)realTimeCommentInstanceDidSelected:(SFRealTimeCommentInstance*)commentInstance;

@end

@interface SFRealTimeCommentInstance : NSObject

@property(nonatomic, weak)id<SFRealTimeCommentInstanceDelegate> commentInstanceDelegate;
@property(nonatomic, strong)id commentData;

@property(nonatomic, assign)CGRect trackBoundingRect;
@property(nonatomic, weak)UIView* commentContentView;
@property(nonatomic, assign)CGFloat commentSpeed;
@property(nonatomic, assign)CGFloat commentDistance;

@property(nonatomic, assign)SFRealTimeCommentStatus status;
@property(nonatomic, assign)BOOL requestStatus;

@property(nonatomic, assign)CGRect currentBoundingRect;

- (instancetype)initWithCommentData:(id)commentData;

- (void)startDisplayComment;
- (void)decorateCommentInstance;

- (void)continueDisplay;
- (void)pauseDisplay;

- (void)comnentInstanceDisplayEnded;
- (void)clear;

- (BOOL)canRespondsTouchEvent;
- (void)sendTouchEvent;

@end

NS_ASSUME_NONNULL_END