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

// 弹幕对象基类
@interface SFRealTimeCommentInstance : NSObject

// 代理
@property(nonatomic, weak)id<SFRealTimeCommentInstanceDelegate> commentInstanceDelegate;

// 弹幕数据
@property(nonatomic, strong)id commentData;

// 弹幕对象复用id，默认为SFRealTimeCommentInstanceDefaultReuseID
@property(nonatomic, strong)NSString* reuseIdentifier;

// 轨道对象frame
@property(nonatomic, assign)CGRect trackBoundingRect;

// 弹幕对象contentView
@property(nonatomic, weak)UIView* commentContentView;

// 弹幕对象速度 commentSpeed和commentDistance用于触发请求下一条弹幕数据
@property(nonatomic, assign)CGFloat commentSpeed;
// 弹幕对象之间的间隔
@property(nonatomic, assign)CGFloat commentDistance;

// YES 当前弹幕处于请求下一条弹幕数据之前的状态
// NO  当前弹幕已经触发过请求下一条弹幕数据，处于请求下一条弹幕数据之后的状态
@property(nonatomic, assign)BOOL requestStatus;

// 弹幕对象当前frame
@property(nonatomic, assign)CGRect currentBoundingRect;

@property(nonatomic, assign)SFRealTimeCommentStatus status;

// 初始化，默认reuseid为SFRealTimeCommentInstanceDefaultReuseID
- (instancetype)initWithCommentData:(id)commentData;
- (instancetype)initWithCommentData:(id)commentData reuseIdentifier:(NSString*)reuseIdentifier;

// 第一次开始展示弹幕,默认调用decorateCommentInstance
- (void)startDisplayComment;
// 子类可以重写decorateCommentInstance方法，在方法中设置弹幕相关数据
- (void)decorateCommentInstance;
- (void)reDecorateCommentInstance;

// 暂停后继续移动弹幕调用continueDisplay
- (void)continueDisplay;

// 暂停弹幕移动
- (void)pauseDisplay;

// 当弹幕显示完毕后自动调用comnentInstanceDisplayEnded方法，通过代理方法触发请求下一条弹幕数据
- (void)comnentInstanceDisplayEnded;

// 弹幕显示结束后或者销毁时的清理操作
- (void)clear;

// 弹幕对象自身是否能响应事件
// 比如基于CALayer的弹幕类SFRealTimeCommentLayerInstance的canRespondsTouchEvent方法返回NO，需要在SFRealTimeCommentContentView
// 的hitTest方法中辅助处理弹幕对象的点击事件
// 基于UIView的弹幕类SFRealTimeCommentViewInstance的canRespondsTouchEvent方法返回YES，自身就可以响应事件
- (BOOL)canRespondsTouchEvent;

// 基于UIView的弹幕类，在响应点击事件后，需要调用sendTouchEvent通知上层触发选中弹幕对象的回调
- (void)sendTouchEvent;

// 触发请求下一条弹幕数据
- (void)triggerRequestNextCommentData;

// 基于UIView的弹幕类需要在commentInstanceRunning中更新弹幕对象的位置
- (void)commentInstanceRunning:(NSTimeInterval)interval withPreInstance:(SFRealTimeCommentInstance*)preInstance;

@end

NS_ASSUME_NONNULL_END

// 弹幕对象默认复用ID
extern NSString* const SFRealTimeCommentInstanceDefaultReuseID;

