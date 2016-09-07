//
//  ShowModel.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/19.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ShowLoveModel.h"
@interface ShowModel : NSObject

@property(nonatomic,copy)NSString *userID;//用户名
@property(nonatomic,copy)NSString *leRunID;//乐跑的ID
@property(nonatomic,copy)NSString *showID;//秀的ID
@property(nonatomic,copy)NSString *userHeader;//用户头像
@property(nonatomic,copy)NSString *userName;//用户名
@property(nonatomic,copy)NSString *showContent;//秀的内容
@property(nonatomic,copy)NSMutableArray *imageArray;
//@property(nonatomic,copy)NSString *showImage1;//第一张图片
//@property(nonatomic,copy)NSString *showImage2;//第二张图片
//@property(nonatomic,copy)NSString *showImage3;//第三张图片
@property(nonatomic,copy)NSString *showTime;//秀的时间
@property(nonatomic,copy)NSString *showLoveCount;//秀的点赞数
@property(nonatomic,copy)NSString *showCommentCount;//秀的评论次数

@property(nonatomic)BOOL isLove;
//@property(nonatomic,copy)NSString *loveCount;
//@property(nonatomic,copy)NSString *commentCount;
@property(nonatomic,copy)NSMutableArray *loveArray;//点赞的数组
@property(nonatomic,copy)NSMutableArray *commentArray;//评论的数组

@end
