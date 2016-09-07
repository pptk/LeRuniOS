//
//  ShowCommentModel.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/19.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowCommentModel : NSObject

@property(nonatomic,copy)NSString *userID;
@property(nonatomic,copy)NSString *commentID;
@property(nonatomic,copy)NSString *userHeader;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *commentContent;
@property(nonatomic,copy)NSString *commentTime;
@property(nonatomic,copy)NSString *evaluateStar;

@end
