//
//  PayViewController.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/8/1.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UILabel *signUpName;
@property (strong, nonatomic) IBOutlet UILabel *signUpEquiment;
@property (strong, nonatomic) IBOutlet UILabel *signUpPayPrice;
@property (strong, nonatomic) IBOutlet UIButton *PayZhiFuBao;
@property (strong, nonatomic) IBOutlet UIButton *PayWeiXin;


@property(copy,nonatomic)NSString *signUpNameStr;//报名者名字
@property(copy,nonatomic)NSString *signUpUserTel;//报名者电话号码
@property(nonatomic,copy)NSString *signUpLeRunTitleStr;//乐跑标题
@property(nonatomic,copy)NSString *signUpLeRunId;//乐跑ID
@property(nonatomic,copy)NSString *signUpPrice;//价格
@property(nonatomic,copy)UIImage *codeImage;//二维码
@property(nonatomic,copy)NSString *lerunOrder;//参与乐跑唯一订单号

@end
