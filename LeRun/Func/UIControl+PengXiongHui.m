//
//  UIControl+PengXionghui.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/26.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "UIControl+PengXionghui.h"

@implementation UIControl(PengXiongHui)

-(void)removeAllTargets{
    for(id target in [self allTargets]){
        [self removeTarget:target action:NULL forControlEvents:UIControlEventAllEvents];
    }
}

@end
