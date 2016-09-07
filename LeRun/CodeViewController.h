//
//  CodeViewController.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/8/12.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITableView *tableViews;
@property(nonatomic,copy)NSString *leRunTitle;//标题
@property(nonatomic,copy)NSString *leRunID;//标题

@end
