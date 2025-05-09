//
//  SFRealTimeCommentFacade.h
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/9.
//

#import <UIKit/UIKey.h>
#import "SFRealtimeCommentHeader.h"
#import "SFRealTimeCommentContentView.h"
#import "SFRealTimeCommentListQueue.h"
#import "SFRealTimeCommentDataSource.h"

NS_ASSUME_NONNULL_BEGIN

// 弹幕框架对外门面类
/*
弹幕系统结构
SFRealTimeCommentFacade 对外门面类
----SFRealTimeCommentListQueue 弹幕数据队列类，负责存储弹幕数据
----SFRealTimeCommentDataSource 弹幕dataSource，负责获取弹幕数据并将数据存入SFRealTimeCommentListQueue中
----SFRealTimeCommentContentView 弹幕contentView，负责显示弹幕。其中包括子系统如下：
    ----SFRealTimeCommentListTrack 弹幕轨道类，负责管理一条轨道中的弹幕对象
        ----SFRealTimeCommentInstance 弹幕对象基类，框架中实现了两个弹幕子类
            ----SFRealTimeCommentLayerInstance 使用CALayer展示弹幕数据，通过动画的方式移动弹幕，轻量级，流畅，但是只能实现弹幕本身的点击
            ----SFRealTimeCommentViewInstance  使用UIView展示弹幕，通过CADisplayLink的回调移动弹幕，当主线程任务较重时，弹幕移动会卡顿，但是可以响应的操作较多
 */

// 弹幕相关操作可以直接使用SFRealTimeCommentFacade类也可以使用SFRealTimeCommentFacade的子类
@interface SFRealTimeCommentFacade : NSObject

// 弹幕队列
@property(nonatomic, strong)SFRealTimeCommentListQueue* commentListQueue;

// 弹幕队列中弹幕数量变化回调
@property(nonatomic, strong)SFRealTimeCommentListQueueCountChangedBlock listQueueCountChangedBlock;

// 弹幕数据加入队列之前弹幕数据处理回调，子线程中执行
@property(nonatomic, strong)SFRealTimeCommentListQueueDealCommentDataBlock listQueueDealCommentBlock;

// 弹幕数据dataSource，负责获取弹幕数据并将数据添加到commentListQueue中
@property(nonatomic, strong)SFRealTimeCommentDataSource* commentListDataSource;

// 展示弹幕的contentView
@property(nonatomic, strong)SFRealTimeCommentContentView* commentContentView;

// 获取自定义轨道对象类型的回调
@property(nonatomic, strong)SFRealTimeCommentCustomTrackBlock getCustomTrackBlock;

// 获取自定义弹幕对象类型的回调
@property(nonatomic, strong)SFRealTimeCommentCustomInstanceBlock getCustomInstanceBlock;

// 点击屏幕中弹幕的回调
@property(nonatomic, strong)SFRealTimeCommentTapInstanceBlock tapInstanceBlock;

// 弹幕是否使用layer展示，默认NO。使用layer展示的弹幕只能响应点击事件
@property(nonatomic, assign)BOOL useCoreAnimation;

// 弹幕系统的状态
@property(nonatomic, assign)SFRealTimeCommentStatus status;

// 初始化弹幕门面类
// containerView commentContentView的superView
- (instancetype)initWithCommentContainerView:(UIView*)containerView;

// 初始化时自动调用，子类可以重写此方法自定义facade中commentListQueue，commentListDataSource，commentContentView等子系统的类型
- (void)makeupFacade;
- (void)setupDefaultComponent;

// 获取自定义轨道对象类型的回调。getCustomTrackBlock默认实现为调用此方法
- (SFRealTimeCommentListTrack*)getCustomCommentTrackWithIndex:(NSInteger)trackIndex;

// 获取自定义弹幕对象类型的回调。getCustomInstanceBlock默认实现为调用此方法
- (SFRealTimeCommentInstance*)getCustomCommentInstanceWithData:(id)commentData;

// 通过identifer查找可复用的弹幕对象
- (SFRealTimeCommentInstance*)reuseCommentInstanceWithIdentifier:(NSString*)identifier commentData:(id)commentData;

// 弹幕队列中弹幕数量变化回调。listQueueCountChangedBlock默认实现为调用此方法
- (void)commentListQueueCountChanged:(NSInteger)count;

// 点击屏幕中弹幕的回调。tapInstanceBlock默认实现为调用此方法
- (void)tapCommentInstance:(SFRealTimeCommentInstance *)instance;

// 搜索指定弹幕对象
- (SFRealTimeCommentInstance*)searchCommentInstanceWithBlock:(SFRealTimeCommentSearchInstanceBlock)searchBlock;

// 删除指定弹幕对象
- (void)removeCommentInstance:(SFRealTimeCommentInstance*)commentInstance;

@end

NS_ASSUME_NONNULL_END
