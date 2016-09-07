//
//  DetailViewController.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/14.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeRunModel.h"
#import "NumberWordLabel.h"
@interface DetailViewController : BaseViewController

@property(nonatomic,copy)NSString *leRunID;

@property(nonatomic,strong)LeRunModel *model;

@property (strong, nonatomic) IBOutlet UIImageView *detailHeaderImage;
@property (strong, nonatomic) IBOutlet NumberWordLabel *detailPrice;
@property (strong, nonatomic) IBOutlet UILabel *detailOverPlus;

@property (strong, nonatomic) IBOutlet NumberWordLabel *detailCountDown;
@property (strong, nonatomic) IBOutlet UIImageView *detailMapImage;
@property (strong, nonatomic) IBOutlet UILabel *detailAddress;//地址
@property (strong, nonatomic) IBOutlet UILabel *timeTitle;//时间
@property (strong, nonatomic) IBOutlet UILabel *leRunTitle;//标题

@property (strong, nonatomic) IBOutlet UILabel *lerunStartTime;
@property (strong, nonatomic) IBOutlet UILabel *leRunEndTime;
@property (strong, nonatomic) IBOutlet UILabel *leRunTime;//举行时间
@property (strong, nonatomic) IBOutlet UILabel *rountineLabel;//活动路线



//@property (strong, nonatomic) IBOutlet UIButton *signBtn;

@property (strong, nonatomic) IBOutlet UILabel *mustKnow;//乐跑须知

@end
