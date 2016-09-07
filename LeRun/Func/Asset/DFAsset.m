//
//  DFAsset.m
//  GetImage
//
//  Created by ianc-ios on 15/9/19.
//  Copyright (c) 2015年 DeadFish7/25. All rights reserved.
//

#import "DFAsset.h"

@interface DFAsset()
{
    UIImageView *assetImageView;//展示每一张图片的UIImageView
}
@end

@implementation DFAsset
#pragma mark 初始化视图
-(id)initWithAsset:(ALAsset *)asset{
    if(self = [super initWithFrame:CGRectZero]){
        //根据传入的asset创建UIImageView
        self.asset = asset;
        assetImageView = [[UIImageView alloc]init];
        assetImageView.contentMode = UIViewContentModeScaleAspectFill;
        assetImageView.image = [UIImage imageWithCGImage:[self.asset thumbnail]];
        [self addSubview:assetImageView];
        //add选中的图片。设置隐藏
        selectedView = [[UIImageView alloc]init];
        selectedView.image = [UIImage imageNamed:@"selected_yes.png"];
        
        selectedView.hidden = YES;
        [self addSubview:selectedView];
    }
    return self;
}
#pragma mark 修改显示与否
-(void)toggleSelection{
    selectedView.hidden = !selectedView.hidden;
}
-(BOOL)selected{
    return !selectedView.hidden;
}
#pragma 设置View的Frame
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    assetImageView.frame = self.bounds;
//    selectedView.frame = self.bounds;
    selectedView.frame = CGRectMake(5, 5, 20, 20);
}


//#pragma mark change selected hidden属性
//-(BOOL)selected{
//    return !selectedView.hidden;
//}
//#pragma mark change selected hidden 属性
//-(void)setSelected:(BOOL)_selected{
//    [selectedView setHidden:!_selected];
//}

@end
