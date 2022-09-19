//
//  SFStockDetailsRTCViewInstance.m
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/19.
//

#import "SFStockDetailsRTCViewInstance.h"

@implementation SFStockDetailsRTCViewInstance

- (void)decorateCommentInstance{
    NSString* commentText = [self.commentData objectForKey:@"commentText"];
    
    UIFont* font = [UIFont systemFontOfSize:12];
    CGSize sizeText = [commentText boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    self.commentView.frame = CGRectMake(0, 0, sizeText.width + 20, 30);
    
    UILabel* label = [[UILabel alloc] initWithFrame:self.commentView.bounds];
    label.text = commentText;
    label.font = font;
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.commentView addSubview:label];
    
    self.commentView.backgroundColor = [UIColor grayColor];
    self.commentView.layer.cornerRadius = self.commentView.bounds.size.height/2;
    self.commentView.layer.masksToBounds = YES;
    
    [super decorateCommentInstance];
}

@end
