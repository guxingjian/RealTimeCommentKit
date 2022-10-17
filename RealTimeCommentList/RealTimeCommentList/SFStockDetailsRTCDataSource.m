//
//  SFStockDetailsRTCDataSource.m
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/14.
//

#import "SFStockDetailsRTCDataSource.h"

@interface SFStockDetailsRTCDataSource()

@end

@implementation SFStockDetailsRTCDataSource

- (instancetype)init{
    if(self = [super init]){
        self.resetTimeInterval = 1;
    }
    return self;
}

- (void)setStatus:(SFRealTimeCommentStatus)status{
    if(status == [super status]){
        return ;
    }
    
    [super setStatus:status];
    
    if(SFRealTimeCommentStatus_Running == status){
        [self fetchRealTimeComment];
    }else if(SFRealTimeCommentStatus_Clean == status){
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}

- (void)fetchRealTimeComment{
    NSArray* arrayComment = @[@"我是弹幕", @"涨停啦", @"快点涨", @"涨起来了涨起来了", @"破股票又跌了", @"没救了没救了", @"啦啦啦", @"快买快买", @"卖了卖了", @"我是弹幕11111", @"给我点赞", @"点赞点赞"];
    
    NSInteger commentCount = 10;
    NSMutableArray* arraySubComment = [NSMutableArray array];
    for(NSInteger i = 0; i < commentCount; ++ i){
        NSString* strComment = [arrayComment objectAtIndex:(random()%arrayComment.count)];
        NSMutableDictionary* dicComment = [NSMutableDictionary dictionary];
        [dicComment setObject:strComment forKey:@"commentText"];
        [arraySubComment addObject:dicComment];
    }
    
    [self.commentListQueue addRealTimeCommentsData:arraySubComment onTail:YES];
    
    [self performSelector:@selector(fetchRealTimeComment) withObject:nil afterDelay:_resetTimeInterval inModes:@[NSRunLoopCommonModes]];
}

- (void)setResetTimeInterval:(NSInteger)resetTimeInterval{
    _resetTimeInterval = resetTimeInterval;
    
    if(SFRealTimeCommentStatus_Clean == self.status){
        return ;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self fetchRealTimeComment];
}

@end
