//
//  LoginViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/22.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "LoginViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIImage+Tint.h"
#import "RunViewController.h"
#import "ShowViewController.h"
#import "HistoryViewController.h"
#import "MeViewController.h"
#import "UIImageView+WebCache.h"
#import "RegisterViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSingl];
    [self.navigationController.navigationBar setBarTintColor:NAVBARCOLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.navigationItem.title = @"登录";
//    [FuncPublic hideTabBar:self];
}
//登录成功后的操作
-(void)createSingl{
    if(self.userName){
        self.userNameTextField.text = self.userName;
    }
    if(self.userPwd){
        self.pwdTextField.text = self.userPwd;
    }
    //new信号
    RACSignal *validUserNameSignal = [self.userNameTextField.rac_textSignal map:^id(NSString *value) {
        return @([self isValidUserName:value]);
    }];
    RACSignal *validPwdSignal = [self.pwdTextField.rac_textSignal map:^id(NSString *value) {
        return @([self isValidPwd:value]);
    }];
    
    //KVO绑定
    RAC(self.userNameTextField,backgroundColor) = [validUserNameSignal map:^id(NSString *value) {
        if([value boolValue])
            self.userState.image = [[UIImage imageNamed:@"yes.png"] imageWithTintColor:[UIColor greenColor]];
        else self.userState.image = [[UIImage imageNamed:@"wrong.png"] imageWithTintColor:[UIColor redColor]];
        return nil;
    }];
    RAC(self.pwdTextField,backgroundColor) = [validPwdSignal map:^id(NSString *value) {
        if([value boolValue])
            self.pwdState.image = [[UIImage imageNamed:@"yes.png"] imageWithTintColor:[UIColor greenColor]];
        else self.pwdState.image = [[UIImage imageNamed:@"wrong.png"] imageWithTintColor:[UIColor redColor]];
        return nil;
    }];
    
    //聚合信号
    RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validPwdSignal,validUserNameSignal] reduce:^id(NSNumber *userNameValid,NSNumber *passwordValid){
        return @([userNameValid boolValue] &&[passwordValid boolValue]);
    }];
    @weakify(self)
    [signUpActiveSignal subscribeNext:^(NSNumber *signupActive){//聚合信号返回的是YES的时候
        @strongify(self)
        self.loginBtn.enabled = [signupActive boolValue];
        if([signupActive boolValue]){
            [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.loginBtn.backgroundColor = NAVBARCOLOR;//满足条件
        }else{
            [self.loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.loginBtn.backgroundColor = RGBCOLOR(225, 225, 225);//不满足
        }
    }];
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.layer.masksToBounds = YES;
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self startLogin];
    }];
}
//开始登陆
-(void)startLogin{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"user" forKey:FLAG];
    [params setObject:@"1" forKey:SERVER_INDEX];
    [params setObject:self.userNameTextField.text forKey:@"user_id"];
    [params setObject:self.pwdTextField.text forKey:@"user_pwd"];
    
    MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
    [[FuncPublic getAFNetManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [FuncPublic HideHud:hud animating:YES];
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        if([result isEqualToString:@"0"]){
            [FuncPublic ShowAlert:@"账号或者密码错误" ViewController:self action:nil];
        }else if([result isEqualToString:@"1"]){
            [FuncPublic showToast:@"登录成功"];
            [self loginSuccess];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FuncPublic HideHud:hud animating:YES];
        [FuncPublic ShowAlert:@"网络异常" ViewController:self action:nil];
    }];
}
//登录成功操作
-(void)loginSuccess{
    //获取用户数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"user" forKey:FLAG];
    [params setValue:@"4" forKey:SERVER_INDEX];
    [params setValue:self.userNameTextField.text forKey:@"user_id"];
    MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [FuncPublic HideHud:hud animating:YES];
        NSDictionary *result = [responseObject objectForKey:@"result"];
        NSString *headerImage = [NSString stringWithFormat:@"%@/%@",BASE_URL,[result objectForKey:@"user_header"]];//头像
        NSString *userNickName = [result objectForKey:@"user_name"];//昵称
        NSString *userTel = [result objectForKey:@"user_phone"];//电话号码
        //账号密码登录状态。
        [FuncPublic SaveDefaultInfo:self.userNameTextField.text Key:USER_ID];
        [FuncPublic SaveDefaultInfo:self.pwdTextField.text Key:USER_PWD];
        [FuncPublic SaveDefaultInfo:@"true" Key:IS_LOGIN];//已经登录
        [FuncPublic SaveDefaultInfo:userNickName Key:USER_NAME];//昵称
        [FuncPublic SaveDefaultInfo:userTel Key:USER_TEL];
        UIImageView *image = [UIImageView new];
        [image sd_setImageWithURL:[NSURL URLWithString:headerImage]];
        NSData *data = UIImageJPEGRepresentation(image.image, 0.00001);
        [FuncPublic SaveDefaultInfo:data Key:USER_HEADER];//保存头像
        //跳转
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabBar = [story instantiateViewControllerWithIdentifier:@"tabBarController"];
        tabBar.selectedIndex = 3;
        [tabBar.tabBar setTintColor:RGBCOLOR(0x00, 0xbb, 0x9c)];
        [self presentViewController:tabBar animated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [WToast showWithText:HTTP_FAIL];
        [FuncPublic HideHud:hud animating:YES];
    }];
}
- (IBAction)registerAction:(id)sender {
    RegisterViewController *rVC = [RegisterViewController new];
    rVC.fromStr = @"账号注册";
    [self.navigationController pushViewController:rVC animated:YES];
}
- (IBAction)forgetPWD:(id)sender {
    RegisterViewController *rVC = [RegisterViewController new];
    rVC.fromStr = @"找回密码";
    [self.navigationController pushViewController:rVC animated:YES];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //修改跳转后返回按钮的颜色
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

-(BOOL)isValidUserName:(NSString *)text{
    if(text.length == 11){
        return YES;
    }
    return NO;
}
-(BOOL)isValidPwd:(NSString *)text{
    if(5<=text.length && text.length <= 16){
        return YES;
    }
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end