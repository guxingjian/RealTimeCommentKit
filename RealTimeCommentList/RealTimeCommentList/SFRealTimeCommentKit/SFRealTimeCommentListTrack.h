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

typedef SFRealTimeCommentInstance* _Nonnull (^SFRealTimeCommentCustomInstanceBlock)(id commentData);

typedef void (^SFRealTimeCommentSelectInstanceBlock)(SFRealTimeCommentInstance* commentInstance);


@interface SFRealTimeCommentListTrack : NSObject<SFRealTimeCommentInstanceDelegate>

@property(nonatomic, strong)SFRealTimeCommentListQueue* commentListQueue;
@property(nonatomic, assign)CGRect trackBoundingRect;
@property(nonatomic, weak)UIView* commentContentView;

@property(nonatomic, assign)CGFloat commentDistance;
@property(nonatomic, assign)CGFloat commentSpeed;

@property(nonatomic, strong)SFRealTimeCommentCustomInstanceBlock getCustomInstanceBlock;
@property(nonatomic, strong)SFRealTimeCommentSelectInstanceBlock selectInstanceBlock;

@property(nonatomic, assign)NSInteger trackIndex;

@property(nonatomic, assign)SFRealTimeCommentStatus status;
@property(nonatomic, assign)BOOL activeStatus;

- (SFRealTimeCommentInstance*)commentInstanceWithCommentData:(id)commentData;
- (SFRealTimeCommentInstance*)getTapInstanceWithHitPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
