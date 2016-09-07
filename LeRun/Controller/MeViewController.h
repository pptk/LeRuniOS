//
//  MeViewController.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/5.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "BaseViewController.h"
@interface MeViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property(nonatomic,copy)NSString *userNameStr;
@property(nonatomic,copy)NSString *imageViewStr;
@property(nonatomic,copy)NSString *userID;


@end
