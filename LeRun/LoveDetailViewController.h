//
//  LoveDetailViewController.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/8/10.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoveDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *loveTableView;

@property(nonatomic,copy)NSString *showID;

@end
