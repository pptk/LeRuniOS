//
//  HistoryHeader.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/8/9.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeRunModel.h"
//@protocol DelegateClick <NSObject>
//-(void)historyHeader:(LeRunModel *)model;
//@end

@interface HistoryHeader : UIView

//@property(retain,nonatomic)id<DelegateClick> delegate;
@property(nonatomic,copy)LeRunModel *model;
@property (strong, nonatomic) IBOutlet UIImageView *postImageView;
@property (strong, nonatomic) IBOutlet UIImageView *startImageView1;
@property (strong, nonatomic) IBOutlet UIImageView *startImageView2;
@property (strong, nonatomic) IBOutlet UIImageView *startImageView3;
@property (strong, nonatomic) IBOutlet UIImageView *startImageView4;
@property (strong, nonatomic) IBOutlet UIImageView *startImageView5;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;//分数
@property (strong, nonatomic) IBOutlet UILabel *historyTitleLabel;//名称
@property (strong, nonatomic) IBOutlet UILabel *historyTimeLabel;//时间
@property (strong, nonatomic) IBOutlet UILabel *hostLabel;//主办方
@property (strong, nonatomic) IBOutlet UILabel *takePartIn;//参与人数

@property (strong, nonatomic) IBOutlet UITextView *historyContent;//内容介绍


@end
