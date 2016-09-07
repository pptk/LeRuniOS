//
//  AboutViewController.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/8/4.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *versionLabe;
@property (strong, nonatomic) IBOutlet UIView *updateView;
@property (strong, nonatomic) IBOutlet UIView *errorBackView;
@property (strong, nonatomic) IBOutlet UIView *askMe;

@end
