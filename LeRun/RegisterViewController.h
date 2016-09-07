//
//  RegisterViewController.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/25.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property(nonatomic,copy)NSString *fromStr;

@property (strong, nonatomic) IBOutlet UITextField *telPhoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *codeTextField;
@property (strong, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (strong, nonatomic) IBOutlet UIButton *registBtn;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;

@end
