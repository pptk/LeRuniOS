//
//  headerView.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/13.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "headerView.h"
#import "PictureScrollView.h"
#import "FuncPublic.h"
@implementation headerView

-(instancetype)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
        NSArray *views = [[NSBundle mainBundle]loadNibNamed:@"headerView" owner:nil options:nil];
        self = views[0];
        //轮播
        self.pictureSV.frame = CGRectMake(0, 0, DEVW, 160);
        NSMutableArray *array = [NSMutableArray array];
        for(NSInteger i = 0;i<5;i++){
            [array addObject:@"http://www.thecolorrun.com.cn/upload/site/1074/img/ibn/20160322/20160322011556711.jpg"];
        }
        self.pictureSV.slideImagesArray = array;
        //点击响应
        self.pictureSV.pictureSelectBlock = ^(NSInteger i){
            NSLog(@"你点击了%ld长图片",(long)i);
        };
        //当前位置
        self.pictureSV.pictureCurrentIndex = ^(NSInteger index){
            NSLog(@"测试一下到   %ld",(long)index);
        };
        self.pictureSV.pageControlPageIndicatorTintColor = RGB(255, 224, 247);
        self.pictureSV.pageControlCurrentPageIndicatorTintColor = [UIColor colorWithRed:67/255.0f green:174/255.0f blue:168/255.0f alpha:1];
        self.pictureSV.autoTime = [NSNumber numberWithFloat:4.0f];
        [self.pictureSV startLoading];
        [self addSubview:self.pictureSV];
        
    }
    return self;
}
-(void)setHotActivity:(UIImage *)image1 image2:(UIImage *)image2{
    
}
@end
