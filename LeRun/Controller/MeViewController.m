//
//  MeViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/5.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "MeViewController.h"
#import "FuncPublic.h"
#import "UIImageView+WebCache.h"
#import "PersonInfoViewController.h"
#import "LoginViewController.h"
#import "HistoryViewController.h"
#import "MyLeRunViewController.h"
#import "MyShowViewController.h"
#import "SettingViewController.h"
#import "AboutViewController.h"
#import "ShowViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface MeViewController ()

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createNav];
}
-(void)viewWillAppear:(BOOL)animated{
    [self createUI];
}
-(void)viewDidAppear:(BOOL)animated{
    [FuncPublic showTabBar:self];
}
-(void)createNav{
    [self.navigationController.navigationBar    setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];//设置文字白色
    self.navigationItem.title = @"我";
    //    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];//设置返回为白色
}
-(void)createUI{
    //个人资料
    UIView *headerView = [FuncPublic InstanceSimpleView:CGRectMake(0, 30, DEVW, 80) backgroundColor:[UIColor whiteColor] addToView:self.mainScrollView];
    {
        [FuncPublic InstanceSimpleView:CGRectMake(0, 0, DEVW, 0.5) backgroundColor:RGB(205, 205, 205) addToView:headerView];
        [FuncPublic InstanceSimpleView:CGRectMake(0, CGRectGetHeight(headerView.frame)-0.5, DEVW, 0.5) backgroundColor:RGB(205, 205, 205) addToView:headerView];
        UIImageView *headerImageView = [FuncPublic InstanceSimpleImageView:nil Rect:CGRectMake(10, 10, 60, 60) userInteractionEnabled:NO alpha:1 addtoView:headerView andTag:0];
        headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        if([FuncPublic isEmpty:[FuncPublic GetDefaultInfo:USER_HEADER]]){
            headerImageView.image = [UIImage imageNamed:@"default_avtar.jpg"];
        }else{
            headerImageView.image = [UIImage imageWithData:[FuncPublic GetDefaultInfo:USER_HEADER]];
        }
        headerImageView.layer.masksToBounds = YES;
        headerImageView.layer.cornerRadius = 5;
        headerImageView.layer.borderColor = LINECOLOR.CGColor;
        headerImageView.layer.borderWidth = 0.5;
        UILabel *nameLabel = [FuncPublic InstanceSimpleLabel:@"未登录" Rect:CGRectMake(CGRectGetMaxX(headerImageView.frame)+10, 10, 150, 30) addToView:headerView Font:[UIFont systemFontOfSize:17] andTextColor:RGBCOLOR(47, 47, 47) backgroundColor:[UIColor clearColor] Aligment:0];
        if([FuncPublic GetDefaultInfo:USER_NAME]){
            nameLabel.text = [NSString stringWithFormat:@"%@",[FuncPublic GetDefaultInfo:USER_NAME]];
            if([[FuncPublic GetDefaultInfo:USER_NAME] isEqualToString:@""])
                nameLabel.text = @"佚名";
        }
        UILabel *idLabel = [FuncPublic InstanceSimpleLabel:@"账号:" Rect:CGRectMake(CGRectGetMaxX(headerImageView.frame)+10, CGRectGetMaxY(nameLabel.frame), 150, 30) addToView:headerView Font:[UIFont systemFontOfSize:14] andTextColor:RGBCOLOR(47, 47, 47) backgroundColor:[UIColor clearColor] Aligment:0];
        if([FuncPublic GetDefaultInfo:USER_ID]){
            idLabel.text = [NSString stringWithFormat:@"账号:%@",[FuncPublic GetDefaultInfo:USER_ID]];
        }
    }
    UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc]init];
    [headerView addGestureRecognizer:headerTap];
    [[headerTap rac_gestureSignal] subscribeNext:^(id x) {//跳转到个人资料页面
        if([[FuncPublic GetDefaultInfo:IS_LOGIN] isEqualToString:@"true"]){
            PersonInfoViewController *piVC = [PersonInfoViewController new];
            piVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:piVC animated:YES];
        }else{
            LoginViewController *lVC = [[LoginViewController alloc]init];
            lVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:lVC animated:YES];
        }
    }];
    
    //我的乐跑
    UIView *myLeRunView = [FuncPublic InstanceSimpleView:CGRectMake(0, CGRectGetMaxY(headerView.frame)+30, DEVW, 45) backgroundColor:[UIColor whiteColor] addToView:self.mainScrollView];
    {
        [FuncPublic InstanceSimpleView:CGRectMake(0, 0, DEVW, 0.5) backgroundColor:RGB(205, 205, 205) addToView:myLeRunView];
        [FuncPublic InstanceSimpleView:CGRectMake(0, CGRectGetHeight(myLeRunView.frame)-0.5, DEVW, 0.5) backgroundColor:RGB(205, 205, 205) addToView:myLeRunView];
        [FuncPublic InstanceSimpleImageView:[UIImage imageNamed:@"me_myrun.png"] Rect:CGRectMake(10, 10, 25, 25) userInteractionEnabled:NO alpha:1 addtoView:myLeRunView andTag:0];
        [FuncPublic InstanceSimpleLabel:@"我的乐跑" Rect:CGRectMake(45,0,150,45) addToView:myLeRunView Font:[UIFont systemFontOfSize:14] andTextColor:RGB(47, 47, 47) backgroundColor:[UIColor clearColor] Aligment:0];
    }
    UITapGestureRecognizer *leRunTap = [UITapGestureRecognizer new];
    [myLeRunView addGestureRecognizer:leRunTap];
    [[leRunTap rac_gestureSignal] subscribeNext:^(id x) {
        MyLeRunViewController *myLRVC = [MyLeRunViewController new];
        myLRVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myLRVC animated:YES];
    }];
    
    //我的秀
    UIButton *myShowBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(myLeRunView.frame), DEVW, 45)];
    myShowBtn.backgroundColor = [UIColor whiteColor];
    
    [self.mainScrollView addSubview:myShowBtn];
    {
        [FuncPublic InstanceSimpleView:CGRectMake(0, CGRectGetHeight(myShowBtn.frame)-0.5, DEVW, 0.5) backgroundColor:RGB(205, 205, 205) addToView:myShowBtn];
        [FuncPublic InstanceSimpleImageView:[UIImage imageNamed:@"me_myshow.png"] Rect:CGRectMake(10, 10, 25, 25) userInteractionEnabled:NO alpha:1 addtoView:myShowBtn andTag:0];
        [FuncPublic InstanceSimpleLabel:@"我的秀" Rect:CGRectMake(45,0,150,45) addToView:myShowBtn Font:[UIFont systemFontOfSize:14] andTextColor:RGB(47, 47, 47) backgroundColor:[UIColor clearColor] Aligment:0];
    }
    [[myShowBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        MyShowViewController *msVC = [MyShowViewController new];
        if([FuncPublic isNilOrEmpty:[FuncPublic GetDefaultInfo:IS_LOGIN]]){
            [WToast showWithText:NO_LOGIN];
            LoginViewController *lVC = [LoginViewController new];
            lVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:lVC animated:YES];
            return;
        }
        msVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:msVC animated:YES];
//        ShowViewController *showVC = [ShowViewController new];
//        [self.navigationController pushViewController:showVC animated:YES];
    }];
    
    //设置
    UIView *setView = [FuncPublic InstanceSimpleView:CGRectMake(0, CGRectGetMaxY(myShowBtn.frame)+30, DEVW, 45) backgroundColor:[UIColor whiteColor] addToView:self.mainScrollView];
    {
        [FuncPublic InstanceSimpleView:CGRectMake(0, 0, DEVW, 0.5) backgroundColor:RGB(205, 205, 205) addToView:setView];
        [FuncPublic InstanceSimpleView:CGRectMake(0, CGRectGetHeight(setView.frame)-0.5, DEVW, 0.5) backgroundColor:RGB(205, 205, 205) addToView:setView];
        [FuncPublic InstanceSimpleImageView:[UIImage imageNamed:@"setting_icon.png"] Rect:CGRectMake(10, 10, 25, 25) userInteractionEnabled:NO alpha:1 addtoView:setView andTag:0];
        [FuncPublic InstanceSimpleLabel:@"设置" Rect:CGRectMake(45,0,150,45) addToView:setView Font:[UIFont systemFontOfSize:14] andTextColor:RGB(47, 47, 47) backgroundColor:[UIColor clearColor] Aligment:0];
    }
    UITapGestureRecognizer *setTap = [UITapGestureRecognizer new];
    [setView addGestureRecognizer:setTap];
    [[setTap rac_gestureSignal] subscribeNext:^(id x) {
        SettingViewController *setVC = [SettingViewController new];
        setVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setVC animated:YES];
    }];
    
    //关于我
    UIView *aboutMeView = [FuncPublic InstanceSimpleView:CGRectMake(0, CGRectGetMaxY(setView.frame), DEVW, 45) backgroundColor:[UIColor whiteColor] addToView:self.mainScrollView];
    {
//        [FuncPublic InstanceSimpleView:CGRectMake(0, 0, DEVW, 0.5) backgroundColor:RGB(205, 205, 205) addToView:aboutMeView];
        [FuncPublic InstanceSimpleView:CGRectMake(0, CGRectGetHeight(aboutMeView.frame)-0.5, DEVW, 0.5) backgroundColor:RGB(205, 205, 205) addToView:aboutMeView];
        [FuncPublic InstanceSimpleImageView:[UIImage imageNamed:@"me_aboutme.png"] Rect:CGRectMake(10, 10, 25, 25) userInteractionEnabled:NO alpha:1 addtoView:aboutMeView andTag:0];
        [FuncPublic InstanceSimpleLabel:@"关于我们" Rect:CGRectMake(45,0,150,45) addToView:aboutMeView Font:[UIFont systemFontOfSize:14] andTextColor:RGB(47, 47, 47) backgroundColor:[UIColor clearColor] Aligment:0];
    }
    UITapGestureRecognizer *aboutTap = [UITapGestureRecognizer new];
    [aboutMeView addGestureRecognizer:aboutTap];
    [[aboutTap rac_gestureSignal] subscribeNext:^(id x) {
        AboutViewController *aVC = [AboutViewController new];
        aVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aVC animated:YES];
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
