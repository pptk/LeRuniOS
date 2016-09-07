//
//  headerView.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/13.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureScrollView.h"


@protocol DelegateClick <NSObject>

-(void)activityClick;//跳转到活动
-(void)themeClick;//跳转到主题
-(void)trackClick;//跳转到足迹
-(void)signClick;//签到操作
-(void)vedioClick:(NSString *)url;//跳转到视频
-(void)leRunClick1;
-(void)leRunClick2;
-(void)pictureScrollViewClick:(NSString *)url;

@end

@interface HeaderView : UIView


@property(retain,nonatomic)id<DelegateClick> delegate;

@property (strong, nonatomic) IBOutlet PictureScrollView *pictureSV;

@property (strong, nonatomic) IBOutlet UIButton *hotBtn1;
@property (strong, nonatomic) IBOutlet UIButton *hotBtn2;
@property (strong, nonatomic) IBOutlet UIButton *vedioImage;

@property (strong, nonatomic) IBOutlet UIView *activityView;
@property (strong, nonatomic) IBOutlet UIView *themeView;
@property (strong, nonatomic) IBOutlet UIView *trackView;
@property (strong, nonatomic) IBOutlet UIView *signView;

//@property(nonatomic,copy)NSString *lerun1Image;
//@property(nonatomic,copy)NSString *lerun1ID;
//@property(nonatomic,copy)NSString *lerun2Image;
//@property(nonatomic,copy)NSString *lerun2ID;
@property(nonatomic,copy)NSMutableArray *modelArray;



@end
