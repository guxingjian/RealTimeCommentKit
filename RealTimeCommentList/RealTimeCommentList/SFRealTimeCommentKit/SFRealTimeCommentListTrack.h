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

@interface SFRealTimeCommentListTrack : NSObject<SFRealTimeCommentInstanceDelegate>

@property(nonatomic, weak)id<SFRealTimeCommentListTrackDelegate> trackDelegate;
@property(nonatomic, strong)SFRealTimeCommentListQueue* commentListQueue;
@property(nonatomic, assign)CGRect trackBoundingRect;
@property(nonatomic, weak)UIView* commentContentView;

@property(nonatomic, assign)CGFloat commentDistance;
@property(nonatomic, assign)CGFloat commentSpeed;

@property(nonatomic, strong)SFRealTimeCommentSelectInstanceBlock selectInstanceBlock;

@property(nonatomic, assign)NSInteger trackIndex;

@property(nonatomic, assign)SFRealTimeCommentStatus status;
@property(nonatomic, assign)BOOL activeStatus;

- (SFRealTimeCommentInstance*)getTapInstanceWithHitPoint:(CGPoint)point;
- (BOOL)commentInstanceRunning:(CADisplayLink*)displayLink;
- (SFRealTimeCommentInstance*)searchCommentInstanceWithBlock:(SFRealTimeCommentSearchInstanceBlock)searchBlock;
- (void)removeCommentInstance:(SFRealTimeCommentInstance*)commentInstance;
- (NSInteger)commentInstanceCount;

@end

NS_ASSUME_NONNULL_END
