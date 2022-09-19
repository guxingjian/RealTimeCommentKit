//
//  SFRealTimeCommentLayerInstance.h
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/16.
//

#import "SFRealTimeCommentInstance.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFRealTimeCommentLayerInstance : SFRealTimeCommentInstance<CAAnimationDelegate>

@property(nonatomic, readonly)CALayer* commentLayer;

- (void)addCommentDisplayAnimation;

@end

NS_ASSUME_NONNULL_END
