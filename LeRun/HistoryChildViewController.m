//
//  HistoryChildViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/17.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "HistoryChildViewController.h"

@interface HistoryChildViewController ()

@end

@implementation HistoryChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.automaticallyAdjustsScrollViewInsets = NO; 
}

-(instancetype)init{
    self.graceTime = 300;
    self.backgroundColor = [UIColor whiteColor];
//    [self collectionView:self.tagCollectionView didSelectItemAtIndexPath:indexPath];
    NSArray *titleArray = @[@"卡乐泡泡跑",@"卡乐彩色跑",@"卡乐马拉松",@"卡乐水枪跑",@"卡乐荧光跑"];
    NSArray *classNames = @[@"PapaWViewController",@"ColourViewController",@"MarathonViewController",@"WaterCannonsViewController",@"FluorescenceViewController"];
    if([self initWithTitles:titleArray andSubViewdisplayClassNames:classNames andTagViewHeight:40]){
//        self.view.frame = CGRectMake(0, 0, DEVW, DEVH)
    }
    [self change];
    return self;
}
-(void)refresh{
    [self scrollEnd];   
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
