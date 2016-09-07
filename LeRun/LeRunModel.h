//
//  LeRunModel.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/12.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface LeRunModel : JSONModel

@property(nonatomic,copy)NSString<Optional> *leRunID;//活动ID
@property(nonatomic,copy)NSString<Optional> *leRunTitle;//活动主题
@property(nonatomic,copy)NSString<Optional> *leRunContent;//活动内容
@property(nonatomic,copy)NSString<Optional> *posterImage;//海报图片
@property(nonatomic,copy)NSString<Optional> *leRunTime;//活动时间
@property(nonatomic,copy)NSString<Optional> *leRunMap;//活动地图
@property(nonatomic,copy)NSString<Optional> *leRunRoutine;//活动路线
@property(nonatomic,copy)NSString<Optional> *leRunHost;//主办方
//@property(nonatomic,copy)NSString *leRunCharge;//活动收费金额。
@property(nonatomic,copy)NSString<Optional> *leRunProcess;//活动流程
@property(nonatomic,copy)NSString<Optional> *leRunRuler;//活动规则
@property(nonatomic,copy)NSString<Optional> *leRunState;//活动状态
@property(nonatomic,copy)NSString<Optional> *leRunType;//活动类型
@property(nonatomic,copy)NSString<Optional> *leRunDImage;//活动详情图
@property(nonatomic,copy)NSString<Optional> *leRunAddress;//活动地址
@property(nonatomic,copy)NSString<Optional> *leRunCity;//活动城市
@property(nonatomic,copy)NSString<Optional> *leRunSponsor;//活动赞助商
@property(nonatomic,copy)NSString<Optional> *leRunMaxUser;//活动规定人数
@property(nonatomic,copy)NSString<Optional> *leRunVideo;//活动视频链接
@property(nonatomic,copy)NSString<Optional> *leRunBeginTime;//活动开始报名日期。
@property(nonatomic,copy)NSString<Optional> *leRunEndTime;//活动截止报名日期

@property(nonatomic,copy)NSString<Optional> *chargeType;//收费模式
@property(nonatomic,copy)NSString<Optional> *leRunFreeNum;//免费人数
@property(nonatomic,copy)NSString<Optional> *leRunChargeFree;//免费价格
@property(nonatomic,copy)NSString<Optional> *leRunChargeCommon;//普通费用
@property(nonatomic,copy)NSString<Optional> *leRunChargeVip;//Vip收费
@property(nonatomic,copy)NSString<Optional> *leRunCommonEquipment;//普通套餐内容
@property(nonatomic,copy)NSString<Optional> *leRunVipEquipment;//Vip套餐内容
@property(nonatomic,copy)NSString<Optional> *leRunFreeEquipment;//免费套餐内容

@property(nonatomic,copy)NSString<Optional> *score;
//model中没有，特殊字段请求时返回
@property(nonatomic,copy)NSString<Optional> *leRunSurplus;
//@property(nonatomic)
@property(nonatomic,copy)NSString<Optional> *leRunBrowse;//浏览量
@property(nonatomic,copy)NSString<Optional> *loveCount;//点赞量

@end
