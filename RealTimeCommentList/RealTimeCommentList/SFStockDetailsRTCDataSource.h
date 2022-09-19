//
//  SFStockDetailsRTCDataSource.h
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/14.
//

#import "SFRealTimeCommentDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFStockDetailsRTCDataSource : SFRealTimeCommentDataSource

@property(nonatomic, assign)NSInteger resetTimeInterval;

@end

NS_ASSUME_NONNULL_END
