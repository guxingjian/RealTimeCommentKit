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

typedef SFRealTimeCommentListTrack* _Nonnull (^SFRealTimeCommentCustomTrackBlock)(NSInteger trackIndex);
typedef void (^SFRealTimeCommentTapInstanceBlock)(SFRealTimeCommentInstance* commentInstance);

@interface SFRealTimeCommentContentView : UIView

@property(nonatomic, strong)SFRealTimeCommentListQueue* commentListQueue;
@property(nonatomic, assign)NSInteger trackCount;

@property(nonatomic, strong)SFRealTimeCommentCustomTrackBlock getCustomTrackBlock;
@property(nonatomic, strong)SFRealTimeCommentCustomInstanceBlock getCustomInstanceBlock;
@property(nonatomic, strong)SFRealTimeCommentTapInstanceBlock tapInstanceBlock;

@property(nonatomic, assign)SFRealTimeCommentStatus status;

- (SFRealTimeCommentListTrack*)createCommentListTrackWithIndex:(NSInteger)trackIndex;

@end

NS_ASSUME_NONNULL_END
