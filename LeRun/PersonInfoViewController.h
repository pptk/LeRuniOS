//
//  PersonInfoViewController.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/21.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonInfoViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
//@property (strong, nonatomic) IBOutlet UITableView *personTableView;
@property(nonatomic,copy)NSString *userID;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (strong, nonatomic) IBOutlet UIView *nickNameView;
@property (strong, nonatomic) IBOutlet UILabel *nickNameText;

@property (strong, nonatomic) IBOutlet UIView *telPhoneView;
@property (strong, nonatomic) IBOutlet UILabel *telPhoneText;

@property (strong, nonatomic) IBOutlet UIView *emailView;
@property (strong, nonatomic) IBOutlet UILabel *emailText;

@property (strong, nonatomic) IBOutlet UIView *sexView;
@property (strong, nonatomic) IBOutlet UIButton *boyBtn;
@property (strong, nonatomic) IBOutlet UIButton *girlBtn;




@property (strong, nonatomic) IBOutlet UIView *heightView;
@property (strong, nonatomic) IBOutlet UILabel *heightText;

@property (strong, nonatomic) IBOutlet UIView *weightView;
@property (strong, nonatomic) IBOutlet UILabel *weightLabel;
@property (strong, nonatomic) IBOutlet UIView *addressView;
@property (strong, nonatomic) IBOutlet UILabel *addressText;
@property (strong, nonatomic) IBOutlet UIView *signView;
@property (strong, nonatomic) IBOutlet UILabel *signText;


@end













