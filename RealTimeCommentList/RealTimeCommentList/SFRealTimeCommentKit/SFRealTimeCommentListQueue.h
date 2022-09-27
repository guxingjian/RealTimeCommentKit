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

@interface SFRealTimeCommentListQueue : NSObject

@property(nonatomic, strong)SFRealTimeCommentListQueueCountChangedBlock countChangedBlock;
@property(nonatomic, strong)SFRealTimeCommentListQueueDealCommentDataBlock dealCommentBlock;
@property(nonatomic, assign)NSInteger maxSize;

@property(nonatomic, assign)SFRealTimeCommentStatus status;

- (void)addRealTimeCommentsData:(NSArray*)arrayCommentData onTail:(BOOL)onTail;
- (void)getRealTimeCommentDataWithCallBack:(SFRealTimeCommentListQueueCallBack)callBack;
- (BOOL)dealCommentData:(id)commentData;

- (void)commentListQueueRunning;
- (void)commentListQueueClean;

@end

NS_ASSUME_NONNULL_END
