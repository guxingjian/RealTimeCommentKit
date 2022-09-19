//
//  SFStockDetailsRTCInstance.m
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/15.
//

#import "SFStockDetailsRTCInstance.h"

@implementation SFStockDetailsRTCInstance

- (void)decorateCommentInstance{
    NSString* commentText = [self.commentData objectForKey:@"commentText"];
    
    UIFont* font = [UIFont systemFontOfSize:12];
    CGSize sizeText = [commentText boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    NSAttributedString* attr = [[NSAttributedString alloc] initWithString:commentText attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor redColor]}];
    
    CATextLayer* textLayer = [CATextLayer layer];
    textLayer.frame = CGRectMake(10, 30/2 - sizeText.height/2 - 1, sizeText.width + 2, sizeText.height + 2);
    textLayer.string = attr;
    
    self.commentLayer.bounds = CGRectMake(0, 0, textLayer.frame.size.width + 20, 30);
    self.commentLayer.backgroundColor = [UIColor grayColor].CGColor;
    [self.commentLayer addSublayer:textLayer];
    self.commentLayer.cornerRadius = self.commentLayer.frame.size.height/2;
    self.commentLayer.masksToBounds = YES;
    
    [super decorateCommentInstance];
}

@end
