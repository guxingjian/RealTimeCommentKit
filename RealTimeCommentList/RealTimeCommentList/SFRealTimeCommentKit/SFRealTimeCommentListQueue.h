//
//  SFRealTimeCommentListQueue.h
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/9.
//

#import <Foundation/Foundation.h>
#import "SFRealtimeCommentHeader.h"

NS_ASSUME_NONNULL_BEGIN

typedef BOOL (^SFRealTimeCommentListQueueDealCommentDataBlock)(id commentData);
typedef void (^SFRealTimeCommentListQueueCallBack)(id commentData);
typedef void (^SFRealTimeCommentListQueueCountChangedBlock) (NSInteger count);

// 弹幕数据队列类
@interface SFRealTimeCommentListQueue : NSObject

// 弹幕队列中弹幕数量变化回调。默认为SFRealTimeCommentFacade中的listQueueCountChangedBlock
@property(nonatomic, strong)SFRealTimeCommentListQueueCountChangedBlock countChangedBlock;

// 弹幕数据加入队列之前弹幕数据处理回调，子线程中执行。默认为SFRealTimeCommentFacade中的listQueueDealCommentBlock
@property(nonatomic, strong)SFRealTimeCommentListQueueDealCommentDataBlock dealCommentBlock;

// 队列中可保存的最大弹幕数量，默认为10000
@property(nonatomic, assign)NSInteger maxSize;

@property(nonatomic, assign)SFRealTimeCommentStatus status;

// 向队列中添加弹幕数据
// onTail：YES 弹幕数据添加到队尾，NO 弹幕数据添加到队首
- (void)addRealTimeCommentsData:(NSArray*)arrayCommentData onTail:(BOOL)onTail;

// 异步从队首获取弹幕数据
- (void)getRealTimeCommentDataWithCallBack:(SFRealTimeCommentListQueueCallBack)callBack;

// 当没有设置dealCommentBlock时，在弹幕数据加入到队列前调用dealCommentData方法在子线程中处理弹幕数据
// 返回 NO 弹幕数据异常，不会加入到弹幕队列
//     YES 正常，加入队列
- (BOOL)dealCommentData:(id)commentData;

// 子线程执行，status为running时调用
- (void)commentListQueueRunning;

// 子线程执行，status为clean时调用
- (void)commentListQueueClean;

@end

NS_ASSUME_NONNULL_END
