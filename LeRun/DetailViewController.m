//
//  DetailViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/14.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "SignUpViewController.h"
#import "NumberWordLabel.h"
#import "LoginViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface DetailViewController ()

@end

@implementation DetailViewController
{
    NSTimeInterval timeDistance;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mustKnow.layer.cornerRadius = 15;
    self.mustKnow.layer.masksToBounds = YES;
    [self getData];
//    [FuncPublic hideTabBar:self];
    
}
-(void)getData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
    [params setObject:@"lerun" forKey:FLAG];
    [params setObject:@"1" forKey:SERVER_INDEX];
    [params setObject:self.leRunID forKey:@"lerun_id"];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [FuncPublic HideHud:hud animating:YES];
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        self.model = [LeRunModel new];
        self.model.leRunDImage = [NSString stringWithFormat:@"%@/%@",BASE_URL,[dic objectForKey:@"lerun_dimage"]];
        self.model.leRunChargeFree = [NSString stringWithFormat:@"%@",[dic objectForKey:@"charge_free"]];//免费价格
        self.model.leRunChargeCommon = [NSString stringWithFormat:@"%@",[dic objectForKey:@"charge_common"]];//普通费用
        self.model.leRunChargeVip = [NSString stringWithFormat:@"%@",[dic objectForKey:@"charge_vip"]];//Vip费用
        self.model.leRunCommonEquipment = [dic objectForKey:@"common_equipment"];//普通套餐内容
        self.model.leRunVipEquipment = [dic objectForKey:@"vip_equipment"];//vip套餐内容
        self.model.leRunFreeEquipment = [dic objectForKey:@"free_equipment"];//完全免费套餐内容
        self.model.leRunFreeNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"lerun_freesurplus"]];//免费剩余名额
        self.model.leRunSurplus = [NSString stringWithFormat:@"%@",[dic objectForKey:@"lerun_surplus"]];//剩余名额
        self.model.leRunTime = [dic objectForKey:@"lerun_time"];
        self.model.leRunBeginTime = [dic objectForKey:@"lerun_begintime"];
        self.model.leRunEndTime = [dic objectForKey:@"lerun_endtime"];
        self.model.leRunMap = [NSString stringWithFormat:@"%@/%@",BASE_URL,[dic objectForKey:@"lerun_map"]];//活动地图
        self.model.leRunRoutine = [dic objectForKey:@"lerun_routine"];//活动路线
        self.model.leRunTitle = [dic objectForKey:@"lerun_title"];//活动标题
        //        self.model.leRunProcess = [dic objectForKey:@"lerun_process"];//活动
        //        self.model.leRunContent = [dic objectForKey:@"lerun_content"];
        self.model.leRunAddress = [dic objectForKey:@"lerun_address"];//活动地点
        self.model.chargeType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"charge_mode"]];//活动收费类型。
        self.model.leRunState = [NSString stringWithFormat:@"%@",[dic objectForKey:@"lerun_state"]];
        if([self.model.chargeType isEqualToString:@"1"]){//完全免费
            [self.detailPrice setText:@"￥0" withNumberSize:20 withWordSize:13];
        }else if([self.model.chargeType isEqualToString:@"2"]){//本单位免费，其他收费
            [self.detailPrice setText:@"￥0" withNumberSize:20 withWordSize:13];
        }else if([self.model.chargeType isEqualToString:@"3"]){//完全收费
            [self.detailPrice setText:[NSString stringWithFormat:@"￥%@",self.model.leRunChargeCommon] withNumberSize:20 withWordSize:13];
        }
        [self updateUI];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FuncPublic HideHud:hud animating:YES];
        [WToast showWithText:HTTP_FAIL];
    }];
}
-(void)updateUI{
    [self.detailHeaderImage sd_setImageWithURL:[NSURL URLWithString:self.model.leRunDImage] placeholderImage:[UIImage imageNamed:@"home.jpg"]];
    if([self.model.leRunState isEqualToString:@"0"]){//如果活动结束
        self.detailOverPlus.text = self.model.leRunSurplus;
    }else{
        self.detailOverPlus.text = @"0";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [formatter dateFromString:(NSString *)self.model.leRunEndTime];
    NSDate *nowDate = [NSDate date];//现在时间。
    timeDistance = [date timeIntervalSinceDate:nowDate];//时间差
    int day = timeDistance/(60*60*24);//天
    int hour = (timeDistance - day * (60*60*24))/(60*60);//小时
    int minu = (timeDistance - day * (60*60*24) - hour*60*60)/60;//分钟
    
    if(minu<0){
        day = 0;
        hour = 0;
        minu = 0;
    }
    NSString *countDown = [NSString stringWithFormat:@"%d天%d小时%d分钟",day,hour,minu];
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(changeCountDown) userInfo:nil repeats:YES];
    [self.detailCountDown setText:countDown withNumberSize:12 withWordSize:10];
    self.timeTitle.text = self.model.leRunTime;
    self.detailAddress.text = self.model.leRunAddress;
    [self.detailMapImage sd_setImageWithURL:[NSURL URLWithString:self.model.leRunMap] placeholderImage:[UIImage imageNamed:@"home.jpg"]];
    
    self.leRunTitle.text = self.model.leRunTitle;//活动标题
    self.lerunStartTime.text = [NSString stringWithFormat:@"%@开始活动报名。",self.model.leRunBeginTime];//活动报名开始时间。
    self.leRunEndTime.text = [NSString stringWithFormat:@"%@活动报名截止。",self.model.leRunEndTime];//活动报名结束时间。
    self.leRunTime.text = [NSString stringWithFormat:@"%@举行活动。",self.model.leRunTime];//活动时间。
    //    self.detailAbout.text = self.model.leRunRoutine;
    //    self.detailFlow.text = self.model.leRunProcess;
    //    self.detailRule.text = self.model.leRunRuler;
    UIButton *signBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, DEVH-45, DEVW, 45)];
    if([self.model.leRunState isEqualToString:@"0"]){//报名中
        [signBtn setTitle:@"立即报名" forState:UIControlStateNormal];
        [signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [signBtn setBackgroundColor:[UIColor redColor]];
    }else{
        [signBtn setTitle:@"报名已结束" forState:UIControlStateNormal];
        [signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [signBtn setBackgroundColor:RGB(205, 205, 205)];
    }
    
    [self.view addSubview:signBtn];
    signBtn.alpha = 1;
    [signBtn bringSubviewToFront:self.view];
    [[signBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        if([signBtn.titleLabel.text isEqualToString:@"报名已结束"]){
            [WToast showWithText:@"活动报名已经结束了哦~"];
            return;
        }
        if([FuncPublic isEmpty:[FuncPublic GetDefaultInfo:USER_ID]]){//如果是空的，说明没登录，跳转到登录页面
            LoginViewController *lVC = [LoginViewController new];
            [WToast showWithText:@"请先登录哦"];
            [self.navigationController pushViewController:lVC animated:YES];
        }else{
            SignUpViewController *signVC = [SignUpViewController new];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:self.model.leRunTitle forKey:@"title"];
            [dic setValue:self.model.leRunTime forKey:@"time"];
            [dic setValue:self.model.leRunAddress forKey:@"address"];
            [dic setValue:self.model.chargeType forKey:@"charge_mode"];
            [dic setValue:self.model.leRunFreeNum forKey:@"free_num"];
            [dic setValue:self.leRunID forKey:@"lerun_id"];
            NSMutableArray *tempArray = [NSMutableArray array];
            switch ([self.model.chargeType intValue]) {
                case 1://完全免费
                {
                    NSMutableDictionary *dicss = [NSMutableDictionary dictionary];
                    [dicss setValue:self.model.leRunChargeFree forKey:@"price"];
                    [dicss setValue:self.model.leRunFreeEquipment forKey:@"equipment"];//免费套餐内容
                    [tempArray addObject:dicss];
                }
                    break;
                case 2://免费+收费
                    if(![self.model.leRunChargeFree isEqualToString:@"-1"]){//免费的值
                        NSMutableDictionary *dicss = [NSMutableDictionary dictionary];
                        [dicss setValue:self.model.leRunChargeFree forKey:@"price"];
                        [dicss setValue:self.model.leRunFreeEquipment forKey:@"equipment"];
                        [tempArray addObject:dicss];
                    }
                    if(![self.model.leRunChargeCommon isEqualToString:@"-1"]){
                        NSMutableDictionary *dicss = [NSMutableDictionary dictionary];
                        [dicss setValue:self.model.leRunChargeCommon forKey:@"price"];
                        [dicss setValue:self.model.leRunCommonEquipment forKey:@"equipment"];
                        [tempArray addObject:dicss];
                    }
                    if(![self.model.leRunChargeVip isEqualToString:@"-1"]){
                        NSMutableDictionary *dicss = [NSMutableDictionary dictionary];
                        [dicss setValue:self.model.leRunChargeVip forKey:@"price"];
                        [dicss setValue:self.model.leRunVipEquipment forKey:@"equipment"];
                        [tempArray addObject:dicss];
                    }
                    break;
                case 3://所有的都收费
                    if(![self.model.leRunChargeCommon isEqualToString:@"-1"]){
                        NSMutableDictionary *dicss = [NSMutableDictionary dictionary];
                        [dicss setValue:self.model.leRunChargeCommon forKey:@"price"];
                        [dicss setValue:self.model.leRunCommonEquipment forKey:@"equipment"];
                        [tempArray addObject:dicss];
                    }
                    if(![self.model.leRunChargeVip isEqualToString:@"-1"]){
                        NSMutableDictionary *dicss = [NSMutableDictionary dictionary];
                        [dicss setValue:self.model.leRunChargeVip forKey:@"price"];
                        [dicss setValue:self.model.leRunVipEquipment forKey:@"equipment"];
                        [tempArray addObject:dicss];
                    }
                    break;
                default:
                    break;
            }
            signVC.leRunDic = dic;
            signVC.chargeArray = tempArray;
            [self.navigationController pushViewController:signVC animated:YES];
        }
    }];
}
-(void)changeCountDown{
    timeDistance = timeDistance - 60;
    int day = timeDistance/(60*60*24);//天
    int hour = (timeDistance - day * (60*60*24))/(60*60);//小时
    int minu = (timeDistance - day * (60*60*24) - hour*60*60)/60;//分钟
    NSString *countDown = [NSString stringWithFormat:@"%d天%d小时%d分钟",day,hour,minu];
    [self.detailCountDown setText:countDown withNumberSize:12 withWordSize:10];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
