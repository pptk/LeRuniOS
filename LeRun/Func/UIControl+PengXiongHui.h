//
//  UIControl+PengXionghui.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/26.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl(PengXiongHui)

-(void)removeAllTargets;//移除所有的响应事件   遇到再UITableViewCell中刷新之后绑定事件重复问题。

@end
