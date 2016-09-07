//
//  headerView.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/13.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "HeaderView.h"
#import "PictureScrollView.h"
#import "FuncPublic.h"
#import "WToast.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LeRunModel.h"
@implementation HeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
        NSArray *views = [[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:nil options:nil];
        self = views[0];
        //轮播
        [self initScrollView];
        [self addTap];
        [self videoSet];
    }
    return self;
}
-(void)videoSet{
    //获取图片地址以及点击的url
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:SERVER_INDEX];
    [params setObject:@"lunbo" forKey:FLAG];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *array = [responseObject objectForKey:@"datas"];
        NSString *imageURL = [array[0] objectForKey:@"video_image"];
        NSString *nextURL = [array[0] objectForKey:@"video_url"];
        [self.vedioImage setImageWithURL:[NSURL URLWithString:imageURL] forState:UIControlStateNormal placeholderImage:[[UIImage imageNamed:@"home.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [[self.vedioImage rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
           [self.delegate vedioClick:nextURL]; 
        }];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}
//设置图片
-(void)setModelArray:(NSMutableArray *)modelArray{
    if(self.modelArray != modelArray){
        LeRunModel *model1 = modelArray[0];
        LeRunModel *model2 = modelArray[1];
        [self.hotBtn1 setImageWithURL:[NSURL URLWithString:model1.posterImage] forState:UIControlStateNormal placeholderImage:[[UIImage imageNamed:@"home.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [self.hotBtn2 setImageWithURL:[NSURL URLWithString:model2.posterImage] forState:UIControlStateNormal placeholderImage:[[UIImage imageNamed:@"home.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [[self.hotBtn1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.delegate leRunClick1];
        }];
        [[self.hotBtn2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.delegate leRunClick2];
        }];
    }
}


-(void)initScrollView{
    self.pictureSV.frame = CGRectMake(0, 0, DEVW, 160);
    NSMutableArray *pictureArray = [NSMutableArray array];
    NSMutableArray *urlArray = [NSMutableArray array];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"lunbo" forKey:FLAG];
    [params setObject:@"0" forKey:SERVER_INDEX];
    MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        [FuncPublic HideHud:hud animating:YES];
        NSArray *array = [responseObject objectForKey:@"datas"];
        for(int i = 0;i<array.count;i++){
            [pictureArray addObject:[array[i] objectForKey:@"lunbo_image"]];
            [urlArray addObject:[array[i] objectForKey:@"lunbo_url"]];
        }
        self.pictureSV.slideImagesArray = pictureArray;
        //点击响应
        @weakify(self);
        self.pictureSV.pictureSelectBlock = ^(NSInteger i){
            @strongify(self);
            [self.delegate pictureScrollViewClick:urlArray[i-100]];
        };
        self.pictureSV.pageControlPageIndicatorTintColor = RGB(255, 224, 247);
        self.pictureSV.pageControlCurrentPageIndicatorTintColor = [UIColor colorWithRed:67/255.0f green:174/255.0f blue:168/255.0f alpha:1];
        self.pictureSV.autoTime = [NSNumber numberWithFloat:4.0f];
        [self.pictureSV startLoading];
        [self addSubview:self.pictureSV];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FuncPublic HideHud:hud animating:YES];
        [WToast showWithText:HTTP_FAIL];
    }];
}
-(void)addTap{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.activityView addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.themeView addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.trackView addGestureRecognizer:tap3];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.signView addGestureRecognizer:tap4];
}
-(void)tapAction:(UITapGestureRecognizer *)tap{
    UIView *view = tap.view;
    switch (view.tag) {
        case 1001:
            [self.delegate activityClick];
            break;
        case 1002:
            [self.delegate themeClick];
            break;
        case 1003:
            [self.delegate trackClick];
            break;
        case 1004:
            [self.delegate signClick];
            break;
        default:
            break;
    }
}
@end
