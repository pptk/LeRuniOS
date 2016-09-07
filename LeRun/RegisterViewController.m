//
//  RegisterViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/25.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "RegisterViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SetPwdViewController.h"

@interface RegisterViewController ()
{
    NSTimer *timers;
    int last;
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.fromStr;
    // Do any additional setup after loading the view from its nib.
    
    self.telPhoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.codeTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.getCodeBtn.layer.cornerRadius = 5;
    self.getCodeBtn.layer.masksToBounds = YES;
    
    [self.registBtn setTitle:self.fromStr forState:UIControlStateNormal];
    self.registBtn.layer.cornerRadius = 5;
    self.registBtn.layer.masksToBounds = 5;
    
    //new信号
    RACSignal *validUserNameSignal = [self.telPhoneTextField.rac_textSignal map:^id(NSString *value) {
        return @([self isValidUserName:value]);
    }];
    RACSignal *validPwdSignal = [self.codeTextField.rac_textSignal map:^id(NSString *value) {
        return @([self isValidPwd:value]);
    }];
    
    if([self.fromStr isEqualToString:@"找回密码"]){
        self.detailLabel.hidden = YES;
    }
    
    //聚合信号
    RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validPwdSignal,validUserNameSignal] reduce:^id(NSNumber *userNameValid,NSNumber *passwordValid){
        return @([userNameValid boolValue] &&[passwordValid boolValue]);
    }];
    @weakify(self)
    [signUpActiveSignal subscribeNext:^(NSNumber *signupActive){//聚合信号返回的是YES的时候
        @strongify(self)
        self.registBtn.enabled = [signupActive boolValue];
        if([signupActive boolValue]){
            [self.registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.registBtn.backgroundColor = NAVBARCOLOR;//满足条件
        }else{
            [self.registBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.registBtn.backgroundColor = RGBCOLOR(225, 225, 225);//不满足
        }
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.getCodeBtn setTitle:@"点击发送" forState:UIControlStateNormal];
}

- (IBAction)registerBtn:(id)sender {
    [SMSSDK commitVerificationCode:self.codeTextField.text phoneNumber:self.telPhoneTextField.text zone:@"86" result:^(NSError *error) {
        if(!error){//验证成功
            SetPwdViewController *spVC = [SetPwdViewController new];
            spVC.fromStr = self.fromStr;
            spVC.telStr = self.telPhoneTextField.text;
            [self.navigationController pushViewController:spVC animated:YES];
        }else{//错误信息
            NSLog(@"%@",error);
        }
    }];
}
- (IBAction)getCode:(id)sender {
    if([FuncPublic isMobileNumber:self.telPhoneTextField.text]){
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.telPhoneTextField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
            if(!error){
                last = 60;
                [self.getCodeBtn setBackgroundColor:RGB(225, 225, 225)];
                [self.getCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                timers = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeGetCodeBtn:) userInfo:nil repeats:YES];
            }else{
                [WToast showWithText:@"获取验证码失败，请重新获取"];
            }
        }];
    }else{
        [WToast showWithText:@"手机号格式不正确"];
    }
}
-(void)changeGetCodeBtn:(id)sender{
    if(last >0){
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%ds",last--] forState:UIControlStateNormal];
    }else{
        self.getCodeBtn.userInteractionEnabled = YES;
        [self.getCodeBtn setBackgroundColor:NAVBARCOLOR];
        [self.getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [timers invalidate];
    }
}

-(BOOL)isValidUserName:(NSString *)text{
    if(text.length == 11){
        return YES;
    }
    return NO;
}
-(BOOL)isValidPwd:(NSString *)text{
    if(4<=text.length && text.length <= 16){
        return YES;
    }
    return NO;
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
