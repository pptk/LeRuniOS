//
//  SetPwdViewController.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/28.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetPwdViewController : UIViewController

@property(nonatomic,copy)NSString *fromStr;
@property(nonatomic,copy)NSString *telStr;

@property (strong, nonatomic) IBOutlet UILabel *telLabel;
@property (strong, nonatomic) IBOutlet UITextField *pwdFirstTextField;
@property (strong, nonatomic) IBOutlet UITextField *pwdSecondTextField;
@property (strong, nonatomic) IBOutlet UIButton *changePwd;

@end
