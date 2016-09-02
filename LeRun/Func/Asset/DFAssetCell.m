//
//  DFAssetCell.m
//  GetImage
//
//  Created by ianc-ios on 15/9/19.
//  Copyright (c) 2015年 DeadFish7/25. All rights reserved.
//

#import "DFAssetCell.h"
#import "DFAsset.h"
@implementation DFAssetCell
#pragma mark
-(instancetype)initWithAssets:(NSArray *)assets reuseIdentifier:(NSString *)identifier{
    if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]){
        self.linesAssets = assets;
    }
    return self;
}
#pragma mark 移除
-(void)setAssets:(NSArray *)assets{
    //暂时搞不清楚这个循环的具体作用。移除之前的图片？
    for(UIView *view in self.subviews){
        if([view isKindOfClass:[DFAsset class]]){
            [view removeFromSuperview];
        }
    }
    self.linesAssets = assets;
}
#pragma mark 布局。该方法在修改设置frame的时候会调用。
-(void)layoutSubviews{
    CGFloat h = self.bounds.size.height - topMargin;//计算每个图片的宽高
    CGFloat margin = (self.bounds.size.width - 4*h)/5.0;//计算左侧边距。五个边距+四个图片
    CGRect frame = CGRectMake(margin, topMargin, h, h);
    for(DFAsset * dfAsset in self.linesAssets){
        dfAsset.frame = frame;
        [self addSubview:dfAsset];
        frame.origin.x = frame.origin.x + frame.size.width + margin;
    }
}
@end
