//
//  LoginViewController.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/22.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *userPwd;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userState;
@property (weak, nonatomic) IBOutlet UIImageView *pwdState;

@end
