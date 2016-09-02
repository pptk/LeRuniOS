//
//  PictureScrollView.h
//  PictureCarousel
//
//  Created by ianc-ios on 15/9/12.
//  Copyright (c) 2015年 DeadFish7/25. All rights reserved.
//

#import <UIKit/UIKit.h>
//声明两个block类型
typedef void (^pictureScrollViewSelectBlock)(NSInteger);
typedef void (^pictureScrollViewCurrentIndex)(NSInteger);

@interface PictureScrollView : UIView<UIScrollViewDelegate>

@property(nonatomic,strong)NSMutableArray *slideImagesArray;//存储图片的地址
@property(nonatomic,copy)pictureScrollViewSelectBlock pictureSelectBlock;//图片点击事件
@property(nonatomic,copy)pictureScrollViewCurrentIndex pictureCurrentIndex;//此时的幻灯片图片序号
@property(nonatomic)BOOL withoutPageControl;//是否显示pageControl
@property(nonatomic)BOOL withoutAutoScroll;//是否自动滚动
@property(nonatomic)NSNumber *autoTime;//滚动时间
@property(nonatomic,strong)UIColor *pageControlCurrentPageIndicatorTintColor;//选中页面pageControl的颜色
@property(nonatomic,strong)UIColor *pageControlPageIndicatorTintColor;//非选中状态的颜色

-(void)startLoading;//加载初始化
-(void)startLoadingByIndex:(NSInteger)index;//加载初始化并制定初始图片。


@end
