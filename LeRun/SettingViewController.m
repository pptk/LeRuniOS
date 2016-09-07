//
//  SettingViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/23.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [FuncPublic hideTabBar:self];
    self.navigationItem.title = @"设置";
}
- (IBAction)exitAction:(id)sender {
    [FuncPublic ShowAlert:@"将删除所有本地数据哦~" title:@"是否注销!" ViewController:self action:^{
        //删除数据
        [FuncPublic RemoveDefaultbyKey:IS_LOGIN];
        [FuncPublic RemoveDefaultbyKey:USER_ID];
        [FuncPublic RemoveDefaultbyKey:USER_PWD];
        [FuncPublic RemoveDefaultbyKey:USER_NAME];
        [FuncPublic RemoveDefaultbyKey:USER_HEADER];
        [WToast showWithText:@"注销成功!"];
        [self.navigationController popViewControllerAnimated:YES];
        //跳转到登录页面。
    } cancelAction:^{
        [WToast showWithText:@"取消!"];
    } showEndAction:nil];
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
