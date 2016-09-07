//
//  AboutViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/8/4.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "AboutViewController.h"
#import "RunLeWebViewController.h"
#import "ErrorBackViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(245, 245, 245)];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"关于我们";
//    [FuncPublic hideTabBar:self];
    
    self.versionLabe.text = [NSString stringWithFormat:@"当前版本号:%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    UITapGestureRecognizer *tap1 = [UITapGestureRecognizer new];
    [self.updateView addGestureRecognizer:tap1];
    [[tap1 rac_gestureSignal] subscribeNext:^(id x) {//点击检查更新。
        [self updateAction];
    }];
    
    UITapGestureRecognizer *tap2 = [UITapGestureRecognizer new];
    [self.errorBackView addGestureRecognizer:tap2];
    [[tap2 rac_gestureSignal] subscribeNext:^(id x) {//反馈
        ErrorBackViewController *errorBVC = [ErrorBackViewController new];
        [self.navigationController pushViewController:errorBVC animated:YES];
    }];
}
//官网。
- (IBAction)webSites:(id)sender {
    RunLeWebViewController *webVC = [RunLeWebViewController new];
    webVC.urlStr = @"http://jxkuafu.com";
    webVC.title = @"官网";
    [self.navigationController pushViewController:webVC animated:YES];
}
//合作伙伴
- (IBAction)togetherBtn:(id)sender {
    
}
-(void)updateAction{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/gb/app/yi-dong-cai-bian/id391945719?mt=8"]];
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
