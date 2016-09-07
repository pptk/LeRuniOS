//
//  AdvertViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/8/4.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "AdvertViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface AdvertViewController ()

@end

@implementation AdvertViewController
{
    UIButton *btn;
    int flag;
    UIImageView *imageView;
    NSTimer *timer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVW, DEVH)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = self.image;
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    flag = 2;
    btn = [[UIButton alloc]initWithFrame:CGRectMake(DEVW-120, 30, 100, 30)];
    btn.font = [UIFont systemFontOfSize:16];
    [btn setTitle:@"3秒跳过" forState:UIControlStateNormal];
    [btn setBackgroundColor:RGBA(205, 205, 205, 0.3)];
    btn.layer.cornerRadius = 15;
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeBtn) userInfo:nil repeats:YES];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self toMain:imageView];
    }];
    
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    [imageView addGestureRecognizer:tap];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        NSLog(@"点击广告图片");
    }];
}
-(void)changeBtn{
    if(flag>0){
        [btn setTitle:[NSString stringWithFormat:@"%d秒跳过",flag--] forState:UIControlStateNormal];
    }
    else{
        [self toMain:imageView];
        [timer invalidate];
    }
}
-(void)toMain:(UIImageView *)img{
    [img removeFromSuperview];
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tab = [mainStory instantiateViewControllerWithIdentifier:@"tabBarController"];
    tab.selectedIndex = -1;
    [tab.tabBar setTintColor:RGBCOLOR(0x00, 0xbb, 0x9c)];
    [tab setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:tab animated:YES completion:nil];
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
