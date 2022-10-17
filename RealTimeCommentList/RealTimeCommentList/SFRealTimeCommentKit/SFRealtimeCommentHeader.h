//
//  SFRealtimeCommentHeader.h
//  RealTimeCommentList
//
//  Created by 何庆钊 on 2022/9/15.
//

#ifndef SFRealtimeCommentHeader_h
#define SFRealtimeCommentHeader_h

typedef NS_ENUM(NSInteger, SFRealTimeCommentStatus){
    SFRealTimeCommentStatus_Unknown, // 默认
    SFRealTimeCommentStatus_Running, // 运行
    SFRealTimeCommentStatus_Paused, // 暂停
    SFRealTimeCommentStatus_Clean // 清空
};

#endif /* SFRealtimeCommentHeader_h */
