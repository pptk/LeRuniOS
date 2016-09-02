//
//  ScrollImageModel.m
//  PictureCarousel
//
//  Created by ianc-ios on 15/9/12.
//  Copyright (c) 2015年 DeadFish7/25. All rights reserved.
//

#import "ScrollImageView.h"

@implementation ScrollImageView
#pragma mark initFrame
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.userInteractionEnabled = YES;//可以点击
    }
    return self;
}
#pragma mark 点击方法
-(void)addTarget:(id)target action:(SEL)action{
    self.target = target;
    self.action = action;
}
#pragma mark 重写触摸方法
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //如果self.target 表示的对象中，self.action表示的方法存在的话。
    if([self.target respondsToSelector:self.action]){
        [self.target performSelector:self.action withObject:self];
    }
}

@end
