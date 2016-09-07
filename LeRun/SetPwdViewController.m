//
//  SetPwdViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/28.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "SetPwdViewController.h"
#import "LoginViewController.h"
@interface SetPwdViewController ()

@end

@implementation SetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title  = @"密码设置";
    
    self.pwdFirstTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.pwdSecondTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.changePwd.layer.cornerRadius = 5;
    self.changePwd.layer.masksToBounds = YES;
    self.telLabel.text = self.telStr;
    
    if([self.fromStr isEqualToString:@"账号注册"]){
        [self.changePwd setTitle:@"设置密码" forState:UIControlStateNormal];
    }
    
}
- (IBAction)changePwd:(id)sender {
    if([self.pwdFirstTextField.text isEqualToString:self.pwdSecondTextField.text]){
        MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
        if([self.fromStr isEqualToString:@"找回密码"]){
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:@"user" forKey:FLAG];
            [params setObject:@"3" forKey:SERVER_INDEX];
            [params setObject:self.telStr forKey:@"user_id"];
            [params setObject:@"user_pwd" forKey:@"update_type"];
            [params setObject:self.pwdFirstTextField.text forKey:@"update_values"];
            [[FuncPublic getAFNetManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                [FuncPublic HideHud:hud animating:YES];
                NSData *data = (NSData *)responseObject;
                NSString *state = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                if([state isEqualToString:@"1"]){
                    [WToast showWithText:@"修改成功"];
                    LoginViewController *lVC = [LoginViewController new];
                    lVC.userName = self.telStr;
                    lVC.userPwd = self.pwdFirstTextField.text;
                    [self.navigationController pushViewController:lVC animated:YES];
                }else{
                    [WToast showWithText:HTTP_FAIL];
                }
            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                [WToast showWithText:HTTP_FAIL];
                [FuncPublic HideHud:hud animating:YES];
            }];
            
        }else if([self.fromStr isEqualToString:@"账号注册"]){
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:@"user" forKey:FLAG];
            [params setObject:@"0" forKey:SERVER_INDEX];
            [params setObject:self.telStr forKey:@"user_id"];
            [params setObject:self.pwdFirstTextField.text forKey:@"user_pwd"];
            
            [[FuncPublic getAFNetManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                [FuncPublic HideHud:hud animating:YES];
                NSData *data = (NSData *)responseObject;
                NSString *state = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                if([state isEqualToString:@"1"]){
                    LoginViewController *lVC = [LoginViewController new];
                    lVC.userName = self.telStr;
                    lVC.userPwd = self.pwdFirstTextField.text;
                    [self.navigationController pushViewController:lVC animated:YES];
                }else if([state isEqualToString:@"2"]){
                    [WToast showWithText:@"该手机号已经注册，尝试找回密码。"];
                }else{
                    [WToast showWithText:HTTP_FAIL];
                }
            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                [WToast showWithText:HTTP_FAIL];
                [FuncPublic HideHud:hud animating:YES];
            }];
        }
    }else{
        [WToast showWithText:@"两次输入的密码不一致"];
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
