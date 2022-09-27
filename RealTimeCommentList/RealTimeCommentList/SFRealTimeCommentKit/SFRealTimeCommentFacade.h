//
//  SFRealTimeCommentFacade.h
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/9.
//

#import <UIKit/UIKey.h>
#import "SFRealtimeCommentHeader.h"
#import "SFRealTimeCommentContentView.h"
#import "SFRealTimeCommentListQueue.h"
#import "SFRealTimeCommentDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFRealTimeCommentFacade : NSObject

@property(nonatomic, strong)SFRealTimeCommentListQueue* commentListQueue;
@property(nonatomic, strong)SFRealTimeCommentListQueueCountChangedBlock listQueueCountChangedBlock;
@property(nonatomic, strong)SFRealTimeCommentListQueueDealCommentDataBlock listQueueDealCommentBlock;

@property(nonatomic, strong)SFRealTimeCommentDataSource* commentListDataSource;

@property(nonatomic, strong)SFRealTimeCommentContentView* commentContentView;
@property(nonatomic, strong)SFRealTimeCommentCustomTrackBlock getCustomTrackBlock;
@property(nonatomic, strong)SFRealTimeCommentCustomInstanceBlock getCustomInstanceBlock;
@property(nonatomic, strong)SFRealTimeCommentTapInstanceBlock tapInstanceBlock;

@property(nonatomic, assign)BOOL useCoreAnimation;

@property(nonatomic, assign)SFRealTimeCommentStatus status;

- (instancetype)initWithCommentContainerView:(UIView*)containerView;
- (void)makeupFacade;

- (SFRealTimeCommentListTrack*)getCustomCommentTrackWithIndex:(NSInteger)trackIndex;
- (SFRealTimeCommentInstance*)getCustomCommentInstanceWithData:(id)commentData;
- (SFRealTimeCommentInstance*)reuseCommentInstanceWithIdentifier:(NSString*)identifier commentData:(id)commentData;

- (BOOL)preDealCommentData:(id)commentData;
- (void)commentListQueueCountChanged:(NSInteger)count;
- (void)tapCommentInstance:(SFRealTimeCommentInstance *)instance;
- (SFRealTimeCommentInstance*)searchCommentInstanceWithBlock:(SFRealTimeCommentSearchInstanceBlock)searchBlock;
- (void)removeCommentInstance:(SFRealTimeCommentInstance*)commentInstance;

@end

NS_ASSUME_NONNULL_END
