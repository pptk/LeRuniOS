//
//  WelcomeViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/8/4.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "WelcomeViewController.h"
#import "PictureScrollView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    PictureScrollView *pSV = [PictureScrollView new];
    pSV.frame = CGRectMake(0, 0, DEVW, DEVH);
    NSMutableArray *pictureArray = [NSMutableArray array];
    for(int i = 1;i<=5;i++){
        [pictureArray addObject:[NSString stringWithFormat:@"bg_page_0%d.png",i]];
    }
    pSV.slideImagesArray = pictureArray;
    pSV.pageControlPageIndicatorTintColor = RGB(255, 224, 247);
    pSV.pageControlCurrentPageIndicatorTintColor = [UIColor colorWithRed:67/255.0f green:174/255.0f blue:168/255.0f alpha:1];
    pSV.pictureCurrentIndex = ^(NSInteger i){//到第几页
        if(i == pictureArray.count-1){
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(DEVW*1/5, DEVH*3/4, DEVW*3/5, 50)];
            btn.backgroundColor = NAVBARCOLOR;
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5;
            [btn setTitle:@"进入应用" forState:UIControlStateNormal];
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UITabBarController *tab = [mainStory instantiateViewControllerWithIdentifier:@"tabBarController"];
                tab.selectedIndex = -1;
                [tab.tabBar setTintColor:RGBCOLOR(0x00, 0xbb, 0x9c)];
                [tab setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                [FuncPublic SaveDefaultInfo:@"1" Key:FIRST_LOGIN];
                [self  presentViewController:tab animated:YES completion:nil];
            }];
            [self.view addSubview:btn];
        }
    };
    [pSV startLoading];
    [self.view addSubview:pSV];
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
