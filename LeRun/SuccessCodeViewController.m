//
//  SuccessCodeViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/8/23.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "SuccessCodeViewController.h"

@interface SuccessCodeViewController ()

@end

@implementation SuccessCodeViewController
{
    NSTimer *timer;
    int sec;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"签到二维码";
    if(self.codeImage){
        self.codeImageView.image = self.codeImage;
    }else{
        self.codeImageView.image = [UIImage imageNamed:@"home.jpg"];
    }
    if(self.tipText){
        self.tipLabel.text = self.tipText;
    }
    if([self.fromStr isEqualToString:@"sign"]){//如果是报名页面跳过来的，那么三秒后自动关闭该页面。回到我的页面。
        [self.navigationItem setHidesBackButton:YES];
        self.countDownTime.text = @"3秒后关闭";
        sec = 3;
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goToMain) userInfo:nil repeats:YES];
    }
}
-(void)goToMain{
    if(sec == 0){//跳转操作
        [timer invalidate];
        UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tab = [mainStory instantiateViewControllerWithIdentifier:@"tabBarController"];
        tab.selectedIndex = 3;
        [tab.tabBar setTintColor:RGBCOLOR(0x00, 0xbb, 0x9c)];
        [tab setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:tab animated:YES completion:nil];
        return;
    }
    self.countDownTime.text = [NSString stringWithFormat:@"%d秒后关闭",sec--];
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
