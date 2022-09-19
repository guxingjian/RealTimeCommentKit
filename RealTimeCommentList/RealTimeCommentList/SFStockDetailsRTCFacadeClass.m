//
//  SFStockDetailsRTCFacadeClass.m
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/13.
//

#import "SFStockDetailsRTCFacadeClass.h"
#import "SFStockDetailsRTCDataSource.h"
#import "SFStockDetailsRTCInstance.h"
#import "SFStockDetailsRTCViewInstance.h"

@implementation SFStockDetailsRTCFacadeClass

- (void)makeupFacade{
    [super makeupFacade];
    
    self.commentListDataSource = [[SFStockDetailsRTCDataSource alloc] init];

    self.commentContentView.trackCount = 3;
}

- (SFRealTimeCommentListTrack *)getCustomCommentTrackWithIndex:(NSInteger)trackIndex{
    SFRealTimeCommentListTrack* listTrack = [[SFRealTimeCommentListTrack alloc] init];
    
    listTrack.trackBoundingRect = CGRectMake(0, 10 + 60*trackIndex, self.commentContentView.bounds.size.width, 40);
    listTrack.commentSpeed = 100;
    listTrack.commentDistance = 60;

    return listTrack;
}

- (SFRealTimeCommentInstance *)getCustomCommentInstanceWithData:(id)commentData{
//    SFStockDetailsRTCInstance* rtcInstance = [[SFStockDetailsRTCInstance alloc] initWithCommentData:commentData];
    SFStockDetailsRTCViewInstance* rtcInstance = [[SFStockDetailsRTCViewInstance alloc] initWithCommentData:commentData];
    return rtcInstance;
}

- (void)commentListQueueCountChanged:(NSInteger)count{
    [super commentListQueueCountChanged:count];
    
    NSInteger trackCount = 6;
    if(count <= 12){
        trackCount = 3;
    }else if(count <= 16){
        trackCount = 4;
    }else if(count <= 20){
        trackCount = 5;
    }
    
    self.commentContentView.trackCount = trackCount;
}

- (void)tapCommentInstance:(SFRealTimeCommentInstance *)instance{
    [super tapCommentInstance:instance];
    
    if(SFRealTimeCommentStatus_Running == self.status){
        self.status = SFRealTimeCommentStatus_Paused;
    }else{
        self.status = SFRealTimeCommentStatus_Running;
    }
}

@end
