//
//  CommentViewController.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/8/11.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController

@property(nonatomic,copy)NSString *leRunID;
@property(nonatomic,copy)NSString *telPhone;//参与者电话
@property (strong, nonatomic) IBOutlet UITextField *commentTextField;
@property (strong, nonatomic) IBOutlet UIButton *StarBtn1;
@property (strong, nonatomic) IBOutlet UIButton *StarBtn2;
@property (strong, nonatomic) IBOutlet UIButton *StarBtn3;
@property (strong, nonatomic) IBOutlet UIButton *StarBtn4;
@property (strong, nonatomic) IBOutlet UIButton *StarBtn5;

@end
