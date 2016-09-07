//
//  TrackViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/14.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "TrackViewController.h"
#import "UIImageView+WebCache.h"
@interface TrackViewController ()

@end

@implementation TrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"足迹";
//    [FuncPublic hideTabBar:self];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.trackImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",BASE_URL,@"lerunposter/footmark.png"]] placeholderImage:[UIImage imageNamed:@"home.jpg"]];
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
