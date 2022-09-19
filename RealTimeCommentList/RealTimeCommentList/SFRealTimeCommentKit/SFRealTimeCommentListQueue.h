//
//  SFRealTimeCommentListQueue.h
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



typedef void (^SFRealTimeCommentListQueueCallBack)(id commentData);
typedef void (^SFRealTimeCommentListQueueCountChangedBlock) (NSInteger count);

@interface SFRealTimeCommentListQueue : NSObject

@property(nonatomic, strong)SFRealTimeCommentListQueueCountChangedBlock countChangedBlock;
@property(nonatomic, assign)NSInteger maxSize;

- (void)addRealTimeCommentsData:(NSArray*)arrayCommentData onTail:(BOOL)onTail;
- (void)getRealTimeCommentDataWithCallBack:(SFRealTimeCommentListQueueCallBack)callBack;
- (void)clear;

@end

NS_ASSUME_NONNULL_END
