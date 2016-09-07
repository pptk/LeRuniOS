//
//  CodeModel.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/8/2.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel/JSONModel.h"
@protocol CodeModel<NSObject>
@end

@interface CodeModel : NSObject

@property(nonatomic,copy)NSString<Optional> *leRunID;//活动ID
@property(nonatomic,copy)NSString<Optional> *leRunTitle;//付款状态。
@property(nonatomic,copy)NSString<Optional> *imagePath;//二维码地址
@property(nonatomic,copy)NSString<Optional> *userName;//用户名
@property(nonatomic,copy)NSString<Optional> *signState;//签到状态
@property(nonatomic,copy)NSString<Optional> *chargeState;//付款状态
@property(nonatomic,copy)NSString<Optional> *evaluateState;//评价状态
@property(nonatomic,copy)NSString<Optional> *price;//价格
@property(nonatomic,copy)NSString<Optional> *telPhoneStr;//参与者联系电话
@property(nonatomic,copy)NSString<Optional> *checkState;//审核状态
@property(nonatomic,copy)NSString<Optional> *Orderid;//订单号

@end
