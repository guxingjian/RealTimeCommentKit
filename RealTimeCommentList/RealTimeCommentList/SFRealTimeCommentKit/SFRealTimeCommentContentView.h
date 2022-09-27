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

@interface SFRealTimeCommentContentView : UIView<SFRealTimeCommentListTrackDelegate>

@property(nonatomic, strong)SFRealTimeCommentListQueue* commentListQueue;
@property(nonatomic, assign)NSInteger trackCount;

@property(nonatomic, strong)SFRealTimeCommentCustomTrackBlock getCustomTrackBlock;
@property(nonatomic, strong)SFRealTimeCommentCustomInstanceBlock getCustomInstanceBlock;
@property(nonatomic, strong)SFRealTimeCommentTapInstanceBlock tapInstanceBlock;

@property(nonatomic, assign)BOOL useCoreAnimation;
@property(nonatomic, assign)CGRect currentDisplayingRect;

@property(nonatomic, assign)SFRealTimeCommentStatus status;

- (SFRealTimeCommentListTrack*)createCommentListTrackWithIndex:(NSInteger)trackIndex;
- (SFRealTimeCommentInstance*)reuseCommentInstanceWithIdentifier:(NSString*)identifier commentData:(id)commentData;
- (SFRealTimeCommentInstance*)searchCommentInstanceWithBlock:(SFRealTimeCommentSearchInstanceBlock)searchBlock;
- (void)removeCommentInstance:(SFRealTimeCommentInstance*)commentInstance;
- (SFRealTimeCommentListTrack*)trackAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
