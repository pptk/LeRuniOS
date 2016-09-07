//
//  HistoryViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/5.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryChildViewController.h"
@interface HistoryViewController ()

@end

@implementation HistoryViewController
{
    HistoryChildViewController *hcVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    [self createNav];
    hcVC = [[HistoryChildViewController alloc]init];
//    [self addChildViewController:hcVC];
    [self.view addSubview:hcVC.view];
}
-(void)viewDidAppear:(BOOL)animated{
    [FuncPublic showTabBar:self];
    [hcVC refresh];
}
-(void)createNav{
    [self.navigationController.navigationBar    setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];//设置文字白色
    self.navigationItem.title = @"回顾";
    //    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];//设置返回为白色
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
