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
    self.status = SFRealTimeCommentStatus_Clean;
    
//    NSLog(@"SFRealTimeCommentFacade dealloc--");
}

- (instancetype)initWithCommentContainerView:(UIView*)containerView{
    if(self = [super init]){
        self.realTimeCommentContentView = containerView;
        [self makeupFacade];
        [self setupDefaultComponent];
    }
    return self;
}

- (void)setupDefaultComponent{
    if(!self.commentListQueue){
        self.commentListQueue = [[SFRealTimeCommentListQueue alloc] init];
    }
    
    if(!self.commentContentView){
        self.commentContentView = [[SFRealTimeCommentContentView alloc] initWithFrame:self.realTimeCommentContentView.bounds];
        self.commentContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.realTimeCommentContentView addSubview:self.commentContentView];
    }
    
    if(!self.commentListDataSource){
        self.commentListDataSource = [[SFRealTimeCommentDataSource alloc] init];
    }
}

- (void)makeupFacade{
    __weak SFRealTimeCommentFacade* weakFacade = self;
    
    self.listQueueCountChangedBlock = ^(NSInteger count) {
        [weakFacade commentListQueueCountChanged:count];
    };
    self.listQueueDealCommentBlock = ^BOOL(id  _Nonnull commentData) {
        return [weakFacade.commentListQueue dealCommentData:commentData];
    };
    
    self.getCustomTrackBlock = ^SFRealTimeCommentListTrack * _Nonnull(NSInteger trackIndex) {
        return [weakFacade getCustomCommentTrackWithIndex:trackIndex];
    };
    
    self.getCustomInstanceBlock = ^SFRealTimeCommentInstance * _Nonnull(id  _Nonnull commentData) {
        return [weakFacade getCustomCommentInstanceWithData:commentData];
    };
    
    self.tapInstanceBlock = ^(SFRealTimeCommentInstance * _Nonnull commentInstance) {
        [weakFacade tapCommentInstance:commentInstance];
    };
}

- (void)setCommentListQueue:(SFRealTimeCommentListQueue *)commentListQueue{
    if(![self checkCurrentStatus] || !commentListQueue){
        return ;
    }
    
    _commentListQueue = commentListQueue;
    _commentListQueue.countChangedBlock = self.listQueueCountChangedBlock;
    _commentListQueue.dealCommentBlock = self.listQueueDealCommentBlock;
    
    self.commentListDataSource.commentListQueue = commentListQueue;
    self.commentContentView.commentListQueue = commentListQueue;
}

- (void)setListQueueCountChangedBlock:(SFRealTimeCommentListQueueCountChangedBlock)listQueueCountChangedBlock{
    _listQueueCountChangedBlock = listQueueCountChangedBlock;
    
    self.commentListQueue.countChangedBlock = listQueueCountChangedBlock;
}

- (void)setListQueueDealCommentBlock:(SFRealTimeCommentListQueueDealCommentDataBlock)listQueueDealCommentBlock{
    _listQueueDealCommentBlock = listQueueDealCommentBlock;
    
    self.commentListQueue.dealCommentBlock = listQueueDealCommentBlock;
}

- (void)setCommentListDataSource:(SFRealTimeCommentDataSource *)commentListDataSource{
    if(![self checkCurrentStatus] || !commentListDataSource){
        return ;
    }
    
    _commentListDataSource = commentListDataSource;
    _commentListDataSource.commentListQueue = self.commentListQueue;
}

- (void)setCommentContentView:(SFRealTimeCommentContentView *)commentContentView{
    if(![self checkCurrentStatus] || !commentContentView){
        return ;
    }
    
    _commentContentView = commentContentView;
    _commentContentView.commentListQueue = self.commentListQueue;
    _commentContentView.getCustomTrackBlock = self.getCustomTrackBlock;
    _commentContentView.getCustomInstanceBlock = self.getCustomInstanceBlock;
    _commentContentView.tapInstanceBlock = self.tapInstanceBlock;
    _commentContentView.useCoreAnimation = self.useCoreAnimation;
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

- (BOOL)checkCurrentStatus{
    if(self.status != SFRealTimeCommentStatus_Running){
        return YES;
    }
    NSLog(@"change sub system in not supported after running");
    return NO;
}

- (void)tapCommentInstance:(SFRealTimeCommentInstance *)instance{

}

- (SFRealTimeCommentListTrack*)getCustomCommentTrackWithIndex:(NSInteger)trackIndex{
    return nil;
}

- (SFRealTimeCommentInstance*)getCustomCommentInstanceWithData:(id)commentData{
    return nil;
}

- (SFRealTimeCommentInstance*)reuseCommentInstanceWithIdentifier:(NSString*)identifier commentData:(id)commentData{
    return [self.commentContentView reuseCommentInstanceWithIdentifier:identifier commentData:commentData];
}

- (void)commentListQueueCountChanged:(NSInteger)count{
//    NSLog(@"current count: %ld", count);
}

- (void)setStatus:(SFRealTimeCommentStatus)status{
    if(_status == status){
        return ;
    }
    
    _status = status;
    
    self.commentListQueue.status = status;
    self.commentContentView.status = status;
    self.commentListDataSource.status = status;
}

- (void)setUseCoreAnimation:(BOOL)useCoreAnimation{
    _useCoreAnimation = useCoreAnimation;
    self.commentContentView.useCoreAnimation = useCoreAnimation;
}

- (SFRealTimeCommentInstance*)searchCommentInstanceWithBlock:(SFRealTimeCommentSearchInstanceBlock)searchBlock{
    return [self.commentContentView searchCommentInstanceWithBlock:searchBlock];
}

- (void)removeCommentInstance:(SFRealTimeCommentInstance*)commentInstance{
    [self.commentContentView removeCommentInstance:commentInstance];
}

@end
