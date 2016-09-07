//
//  SuccessCodeViewController.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/8/23.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuccessCodeViewController : UIViewController

@property(nonatomic,copy)UIImage *codeImage;
@property(nonatomic,copy)NSString *tipText;
@property(nonatomic,copy)NSString *fromStr;

@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UIImageView *codeImageView;
@property (strong, nonatomic) IBOutlet UILabel *countDownTime;

@end
