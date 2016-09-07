//
//  SendViewController.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/20.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *inputTextView;
@property (strong, nonatomic) IBOutlet UIView *selectedBackground;
@property (strong, nonatomic) IBOutlet UIButton *selectedBtn;
@property (strong, nonatomic) IBOutlet UILabel *inputSize;

//@property (strong, nonatomic) IBOutlet UIButton *sendBtn;

@end
