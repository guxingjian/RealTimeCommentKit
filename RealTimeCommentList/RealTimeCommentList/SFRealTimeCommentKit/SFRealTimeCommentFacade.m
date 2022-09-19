//
//  SFRealTimeCommentFacade.m
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/9.
//

#import "SFRealTimeCommentFacade.h"

@interface SFRealTimeCommentFacade()

@property(nonatomic, strong)UIView* realTimeCommentContentView;

@end

@implementation SFRealTimeCommentFacade

- (void)dealloc{
    self.status = SFRealTimeCommentStatus_Stop;
    
//    NSLog(@"SFRealTimeCommentFacade dealloc--");
}

- (instancetype)initWithCommentContainerView:(UIView*)containerView{
    if(self = [super init]){
        self.realTimeCommentContentView = containerView;
        [self makeupFacade];
    }
    return self;
}

- (void)makeupFacade{
    __weak SFRealTimeCommentFacade* facade = self;
    
    self.listQueueCountChangedBlock = ^(NSInteger count) {
        [facade commentListQueueCountChanged:count];
    };
    self.commentListQueue = [[SFRealTimeCommentListQueue alloc] init];
    
    self.getCustomTrackBlock = ^SFRealTimeCommentListTrack * _Nonnull(NSInteger trackIndex) {
        return [facade getCustomCommentTrackWithIndex:trackIndex];
    };
    
    self.getCustomInstanceBlock = ^SFRealTimeCommentInstance * _Nonnull(id  _Nonnull commentData) {
        return [facade getCustomCommentInstanceWithData:commentData];
    };
    
    self.tapInstanceBlock = ^(SFRealTimeCommentInstance * _Nonnull commentInstance) {
        [facade tapCommentInstance:commentInstance];
    };
    
    self.commentContentView = [[SFRealTimeCommentContentView alloc] initWithFrame:self.realTimeCommentContentView.bounds];
    self.commentContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.realTimeCommentContentView addSubview:self.commentContentView];
    
    self.commentListDataSource = [[SFRealTimeCommentDataSource alloc] init];
}

- (void)setCommentListQueue:(SFRealTimeCommentListQueue *)commentListQueue{
    if(commentListQueue){
        [self checkCurrentStatus];
    }
    
    _commentListQueue = commentListQueue;
    _commentListQueue.countChangedBlock = self.listQueueCountChangedBlock;
    
    self.commentListDataSource.commentListQueue = commentListQueue;
    self.commentContentView.commentListQueue = commentListQueue;
}

- (void)setListQueueCountChangedBlock:(SFRealTimeCommentListQueueCountChangedBlock)listQueueCountChangedBlock{
    _listQueueCountChangedBlock = listQueueCountChangedBlock;
    
    self.commentListQueue.countChangedBlock = listQueueCountChangedBlock;
}

- (void)setCommentListDataSource:(SFRealTimeCommentDataSource *)commentListDataSource{
    if(commentListDataSource){
        [self checkCurrentStatus];
    }
    
    _commentListDataSource = commentListDataSource;
    _commentListDataSource.commentListQueue = self.commentListQueue;
}

- (void)setCommentContentView:(SFRealTimeCommentContentView *)commentContentView{
    if(commentContentView){
        [self checkCurrentStatus];
    }
    
    _commentContentView = commentContentView;
    _commentContentView.commentListQueue = self.commentListQueue;
    _commentContentView.getCustomTrackBlock = self.getCustomTrackBlock;
    _commentContentView.getCustomInstanceBlock = self.getCustomInstanceBlock;
    _commentContentView.tapInstanceBlock = self.tapInstanceBlock;
}

- (void)setGetCustomTrackBlock:(SFRealTimeCommentCustomTrackBlock)getCustomTrackBlock{
    _getCustomTrackBlock = getCustomTrackBlock;
    
    self.commentContentView.getCustomTrackBlock = getCustomTrackBlock;
}

- (void)setGetCustomInstanceBlock:(SFRealTimeCommentCustomInstanceBlock)getCustomInstanceBlock{
    _getCustomInstanceBlock = getCustomInstanceBlock;
    
    self.commentContentView.getCustomInstanceBlock = getCustomInstanceBlock;
}

- (void)setTapInstanceBlock:(SFRealTimeCommentTapInstanceBlock)tapInstanceBlock{
    _tapInstanceBlock = tapInstanceBlock;
    
    self.commentContentView.tapInstanceBlock = tapInstanceBlock;
}

- (void)checkCurrentStatus{
    NSAssert((SFRealTimeCommentStatus_Unknown == self.status), @"change sub system in not supported after running");
}

- (void)tapCommentInstance:(SFRealTimeCommentInstance *)instance{

}

- (SFRealTimeCommentListTrack*)getCustomCommentTrackWithIndex:(NSInteger)trackIndex{
    return nil;
}

- (SFRealTimeCommentInstance*)getCustomCommentInstanceWithData:(id)commentData{
    return nil;
}

- (void)commentListQueueCountChanged:(NSInteger)count{
//    NSLog(@"current count: %ld", count);
}

- (void)setStatus:(SFRealTimeCommentStatus)status{
    if(_status == status){
        return ;
    }
    
    _status = status;
    
    self.commentListDataSource.status = status;
    self.commentContentView.status = status;
    
    if(SFRealTimeCommentStatus_Stop == status){
        [self.commentListQueue clear];
    }
}

@end
