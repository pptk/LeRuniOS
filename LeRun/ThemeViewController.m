//
//  ThemeViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/14.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "ThemeViewController.h"

@interface ThemeViewController ()

@end

@implementation ThemeViewController
-(instancetype)init{
    NSArray *titleArray = @[@"卡乐泡泡跑",@"卡乐彩色跑",@"卡乐马拉松",@"卡乐水枪跑",@"卡乐荧光跑"];
    NSArray *classNames = @[@"PapaWViewController",@"ColourViewController",@"MarathonViewController",@"WaterCannonsViewController",@"FluorescenceViewController"];
    if(self = [super initWithTitles:titleArray andSubViewdisplayClassNames:classNames andTagViewHeight:40]){
    }
    return self;
}
//-(void)viewWillLayoutSubviews{
//    self.view.frame = CGRectMake(0, 64, DEVW, DEVH-64);
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"主题";
    
    self.graceTime = 300;
    self.backgroundColor = [UIColor whiteColor];
    
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
