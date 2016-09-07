//
//  SignUpViewController.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/27.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : BaseViewController

@property(nonatomic,copy)NSDictionary *leRunDic;
@property(nonatomic,copy)NSMutableArray *chargeArray;


@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;


@property (strong, nonatomic) IBOutlet UILabel *leRunTitle;
@property (strong, nonatomic) IBOutlet UILabel *leRunTime;
@property (strong, nonatomic) IBOutlet UILabel *leRunAddress;
@property (strong, nonatomic) IBOutlet UITextField *signUpName;
@property (strong, nonatomic) IBOutlet UISegmentedControl *signUpSex;
@property (strong, nonatomic) IBOutlet UILabel *signUpCertificatesType;
@property (strong, nonatomic) IBOutlet UITextField *signUpCertificatesID;
@property (strong, nonatomic) IBOutlet UISegmentedControl *signUpClothesSize;
@property (strong, nonatomic) IBOutlet UILabel *signUpWork;
@property (strong, nonatomic) IBOutlet UITextField *signUpFrom;
@property (strong, nonatomic) IBOutlet UITextField *signUpTelphone;
@property (strong, nonatomic) IBOutlet UIButton *signUpSign;//身份认证

@property (strong, nonatomic) IBOutlet UITableView *priceList;

@property (strong, nonatomic) IBOutlet UIButton *signUpSafe;


@property (strong, nonatomic) IBOutlet UIButton *signBtn;


//@property (strong, nonatomic) IBOutlet UIView *certificaType;//证件类型
//@property (strong, nonatomic) IBOutlet UIView *fromWork;//来源单位
//@property (strong, nonatomic) IBOutlet UIView *identityView;//身份




@end
