//
//  ErrorBackViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/8/4.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "ErrorBackViewController.h"
#import "LoginViewController.h"
@interface ErrorBackViewController ()

@end

@implementation ErrorBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"反馈";
    
    
    
}
- (IBAction)sendAction:(id)sender {
    if([FuncPublic isNilOrEmpty:[FuncPublic GetDefaultInfo:USER_ID]]){
        [WToast showWithText:NO_LOGIN];
        LoginViewController *lVC = [LoginViewController new];
        [self.navigationController pushViewController:lVC animated:YES];
        return;
    }
    if([FuncPublic isNilOrEmpty:self.errorTextField.text]){
        [WToast showWithText:SETNULL];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"aboutus" forKey:FLAG];
    [params setObject:@"2" forKey:SERVER_INDEX];
    [params setObject:[FuncPublic GetDefaultInfo:USER_ID] forKey:@"user_id"];
    [params setObject:self.errorTextField.text forKey:@"feedback_content"];
    [params setObject:self.telPhoneTextField.text forKey:@"user_telphone"];
    
    MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *state = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]];
        [FuncPublic HideHud:hud animating:YES];
        if([state isEqualToString:@"1"]){
            [WToast showWithText:@"反馈成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [WToast showWithText:@"反馈失败"];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FuncPublic HideHud:hud animating:YES];
        [WToast showWithText:HTTP_FAIL];
    }];
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
