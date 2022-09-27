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
    
    listTrack.trackBoundingRect = CGRectMake(0, 10 + 50*trackIndex, self.commentContentView.bounds.size.width, 40);
    listTrack.commentSpeed = 100;
    listTrack.commentDistance = 60;

    return listTrack;
}

- (SFRealTimeCommentInstance *)getCustomCommentInstanceWithData:(id)commentData{
    if(!commentData){
        return nil;
    }
    SFRealTimeCommentInstance* commentInstance = [self reuseCommentInstanceWithIdentifier:SFRealTimeCommentInstanceDefaultReuseID commentData:commentData];
    if(!commentInstance){
        commentInstance = [[SFStockDetailsRTCInstance alloc] initWithCommentData:commentData];
    //    commentInstance = [[SFStockDetailsRTCViewInstance alloc] initWithCommentData:commentData];
    }
    
    return commentInstance;
}

- (void)commentListQueueCountChanged:(NSInteger)count{
    [super commentListQueueCountChanged:count];
    
    NSInteger trackCount = 3;
    if(count > 12){
        trackCount = ((count - 12)/4 + 1) + 3;
    }
    
    if(trackCount > 12){
        trackCount = 12;
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
