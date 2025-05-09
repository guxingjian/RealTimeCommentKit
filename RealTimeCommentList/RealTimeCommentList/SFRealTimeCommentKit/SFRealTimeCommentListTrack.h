//
//  SFRealTimeCommentListTrack.h
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/9.
//

#import <UIKit/UIKit.h>
#import "SFRealtimeCommentHeader.h"
#import "SFRealTimeCommentInstance.h"
#import "SFRealTimeCommentListQueue.h"

NS_ASSUME_NONNULL_BEGIN

@class SFRealTimeCommentListTrack;

@protocol SFRealTimeCommentListTrackDelegate <NSObject>

- (void)commentTrack:(SFRealTimeCommentListTrack*)track didAddCommentInstance:(SFRealTimeCommentInstance*)commentInstance;
- (SFRealTimeCommentInstance*)commentTrack:(SFRealTimeCommentListTrack*)track requestNewCommentInstanceWithData:(id)commentData;
- (void)commentTrack:(SFRealTimeCommentListTrack*)track didEndDisplayCommentInstance:(SFRealTimeCommentInstance*)commentInstance;

@end

typedef BOOL (^SFRealTimeCommentSearchInstanceBlock)(SFRealTimeCommentInstance* commentInstance);
typedef void (^SFRealTimeCommentSelectInstanceBlock)(SFRealTimeCommentInstance* commentInstance);


// 弹幕轨道类
@interface SFRealTimeCommentListTrack : NSObject<SFRealTimeCommentInstanceDelegate>

// 代理
@property(nonatomic, weak)id<SFRealTimeCommentListTrackDelegate> trackDelegate;

// 弹幕队列
@property(nonatomic, strong)SFRealTimeCommentListQueue* commentListQueue;

// 轨道frame，弹幕对象默认在trackBoundingRect中垂直居中展示
@property(nonatomic, assign)CGRect trackBoundingRect;

@property(nonatomic, weak)UIView* commentContentView;

// 弹幕之间间隔
@property(nonatomic, assign)CGFloat commentDistance;

// 弹幕移动速度, 点/秒
@property(nonatomic, assign)CGFloat commentSpeed;

// SFRealTimeCommentContentView对象使用的弹幕对象点击回调block
@property(nonatomic, strong)SFRealTimeCommentSelectInstanceBlock selectInstanceBlock;

// 轨道对象的索引
@property(nonatomic, assign)NSInteger trackIndex;

// 当前轨道对象是否处于active状态
// NO 轨道对象继续展示正在移动的弹幕对象，但是不会再展示新的弹幕数据
// YES 正常展示
@property(nonatomic, assign)BOOL activeStatus;
@property(nonatomic, assign)SFRealTimeCommentStatus status;

// 通过point位置获取对应的弹幕对象
- (SFRealTimeCommentInstance*)getTapInstanceWithHitPoint:(CGPoint)point;

// 如果轨道对象中包含的弹幕对象为UIView类型的弹幕，则通过commentInstanceRunning方法执行更新弹幕位置等操作
- (BOOL)commentInstanceRunning:(NSTimeInterval)interval;

// 搜索指定弹幕对象
- (SFRealTimeCommentInstance*)searchCommentInstanceWithBlock:(SFRealTimeCommentSearchInstanceBlock)searchBlock;

// 移除弹幕对象
- (void)removeCommentInstance:(SFRealTimeCommentInstance*)commentInstance;

// 轨道中包含的弹幕对象数量
- (NSInteger)commentInstanceCount;

@end

NS_ASSUME_NONNULL_END
