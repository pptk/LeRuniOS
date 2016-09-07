//
//  HistoryDetailViewController.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/8/8.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryDetailViewController : BaseViewController

@property(nonatomic,copy)NSString *leRunID;
@property (strong, nonatomic) IBOutlet UITableView *historyTableView;
@property (strong, nonatomic) IBOutlet UITextField *inputTextView;//回复输入框

@end
