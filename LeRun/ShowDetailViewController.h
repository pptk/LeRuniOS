//
//  ShowDetailViewController.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/19.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//
#import "ShowModel.h"
#import <UIKit/UIKit.h>

@interface ShowDetailViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITableView *showTableView;

@property(nonatomic,strong)ShowModel *model;
@property (strong, nonatomic) IBOutlet UITextField *inputTextField;
@property (strong, nonatomic) IBOutlet UIButton *sendBtn;
@property (strong, nonatomic) IBOutlet UIView *bottomView;

-(void)commonShare:(id)sender;

@end
