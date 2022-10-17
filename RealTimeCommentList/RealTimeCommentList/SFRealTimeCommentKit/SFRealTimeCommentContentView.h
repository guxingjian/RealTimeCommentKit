//
//  SFRealTimeCommentContentView.h
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/9.
//

#import <UIKit/UIKit.h>
#import "SFRealtimeCommentHeader.h"
#import "SFRealTimeCommentListQueue.h"
#import "SFRealTimeCommentListTrack.h"

NS_ASSUME_NONNULL_BEGIN

typedef SFRealTimeCommentInstance* _Nonnull (^SFRealTimeCommentCustomInstanceBlock)(id commentData);
typedef SFRealTimeCommentListTrack* _Nonnull (^SFRealTimeCommentCustomTrackBlock)(NSInteger trackIndex);
typedef void (^SFRealTimeCommentTapInstanceBlock)(SFRealTimeCommentInstance* commentInstance);

// 弹幕contentView
@interface SFRealTimeCommentContentView : UIView<SFRealTimeCommentListTrackDelegate>

// 弹幕队列类
@property(nonatomic, strong)SFRealTimeCommentListQueue* commentListQueue;

// 轨道数量，通过trackCount设置屏幕中有几条弹幕轨道
@property(nonatomic, assign)NSInteger trackCount;

// 获取自定义轨道对象类型的回调，默认为SFRealTimeCommentFacade中的getCustomTrackBlock
@property(nonatomic, strong)SFRealTimeCommentCustomTrackBlock getCustomTrackBlock;

// 获取自定义弹幕对象类型的回调，默认为SFRealTimeCommentFacade中的getCustomInstanceBlock
@property(nonatomic, strong)SFRealTimeCommentCustomInstanceBlock getCustomInstanceBlock;

// 点击屏幕中弹幕的回调，默认为SFRealTimeCommentFacade中的tapInstanceBlock
@property(nonatomic, strong)SFRealTimeCommentTapInstanceBlock tapInstanceBlock;

// 弹幕是否使用layer展示，默认为SFRealTimeCommentFacade中的useCoreAnimation
@property(nonatomic, assign)BOOL useCoreAnimation;

// 当前弹幕区域frame
@property(nonatomic, assign)CGRect currentDisplayingRect;

@property(nonatomic, assign)SFRealTimeCommentStatus status;

// 通过getCustomTrackBlock创建自定义轨道类型对象或者创建默认的SFRealTimeCommentListTrack类型对象
- (SFRealTimeCommentListTrack*)createCommentListTrackWithIndex:(NSInteger)trackIndex;

// 通过identifer查找可复用的弹幕对象
- (SFRealTimeCommentInstance*)reuseCommentInstanceWithIdentifier:(NSString*)identifier commentData:(id)commentData;

// 搜索指定弹幕对象
- (SFRealTimeCommentInstance*)searchCommentInstanceWithBlock:(SFRealTimeCommentSearchInstanceBlock)searchBlock;

// 删除指定弹幕对象
- (void)removeCommentInstance:(SFRealTimeCommentInstance*)commentInstance;

// 获取指定所以的轨道对象
- (SFRealTimeCommentListTrack*)trackAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
