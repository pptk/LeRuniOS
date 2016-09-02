//
//  ScrollImageModel.h
//  PictureCarousel
//
//  Created by ianc-ios on 15/9/12.
//  Copyright (c) 2015年 DeadFish7/25. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollImageView : UIImageView

@property(nonatomic,assign)id target;
@property(nonatomic,assign)SEL action;
//自定义UIImageVIew拥有点击方法
-(void)addTarget:(id)target action:(SEL)action;

@end
