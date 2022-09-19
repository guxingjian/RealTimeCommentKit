//
//  SFRealTimeCommentDataSource.h
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/9.
//

#import <Foundation/Foundation.h>
#import "SFRealtimeCommentHeader.h"
#import "SFRealTimeCommentListQueue.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFRealTimeCommentDataSource : NSObject

@property(nonatomic, strong)SFRealTimeCommentListQueue* commentListQueue;
@property(nonatomic, assign)SFRealTimeCommentStatus status;

@end

NS_ASSUME_NONNULL_END
