//
//  PayViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/8/1.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "PayViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "SuccessCodeViewController.h"
#import "WXApi.h"
#import "WXApiRequestHandler.h"

@interface PayViewController ()

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"支付";
    self.view.backgroundColor = RGB(245, 245, 245);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.signUpName.text = self.signUpNameStr;
    self.signUpEquiment.text = self.signUpLeRunTitleStr;
    self.signUpPayPrice.text = self.signUpPrice;
    
    [[self.PayWeiXin rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.PayWeiXin.selected = !self.PayWeiXin.selected;
        self.PayZhiFuBao.selected = NO;
    }];
    [[self.PayZhiFuBao rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.PayZhiFuBao.selected = !self.PayZhiFuBao.selected;
        self.PayWeiXin.selected = NO;
    }];
    //获取通知中心单例对象
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者
    [center addObserver:self selector:@selector(notice:) name:@"paySuccess" object:nil];
    
}
-(void)notice:(NSNotification *)sender{
    NSString *payResult = [sender.userInfo objectForKey:@"result"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"5" forKey:SERVER_INDEX];
    [params setObject:@"lerun" forKey:FLAG];
    [params setObject:[FuncPublic GetDefaultInfo:USER_ID] forKey:@"user_id"];
    [params setObject:self.signUpLeRunId forKey:@"lerun_id"];
    [params setObject:payResult forKey:@"payResult"];
    [params setObject:self.signUpPrice forKey:@"payment"];
    [params setObject:self.signUpUserTel forKey:@"user_telphone"];
    [params setObject:@"iOS" forKey:@"from"];
    MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [FuncPublic HideHud:hud animating:YES];
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]];
        if([status isEqualToString:@"0"]){
            //失败
            SuccessCodeViewController *svVC = [SuccessCodeViewController new];
            svVC.codeImage = self.codeImage;
            svVC.tipText = @"网络异常,请检查网络并刷新！\n如有疑问,请及时联系我们。";
            svVC.fromStr = @"sign";
            [self.navigationController pushViewController:svVC animated:YES];
        }else if([status isEqualToString:@"1"]){
            //成功
            SuccessCodeViewController *svVC = [SuccessCodeViewController new];
            svVC.codeImage = self.codeImage;
            svVC.tipText = self.signUpLeRunTitleStr;
            svVC.fromStr = @"sign";
            [self.navigationController pushViewController:svVC animated:YES];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        SuccessCodeViewController *svVC = [SuccessCodeViewController new];
        svVC.codeImage = self.codeImage;
        svVC.tipText = @"网络异常,请检查网络并刷新！\n如有疑问,请及时联系我们。";
        svVC.fromStr = @"sign";
        [self.navigationController pushViewController:svVC animated:YES];
        [FuncPublic HideHud:hud animating:YES];
        [WToast showWithText:HTTP_FAIL];
    }];
}


- (IBAction)payAction:(id)sender {
    if(self.PayZhiFuBao.selected != YES && self.PayWeiXin.selected != YES){
        [WToast showWithText:@"请选择支付方式"];
    }else{//开始支付
        if(self.PayZhiFuBao.selected == YES){
            [self doAlipayPay];//支付宝支付。
        }else if(self.PayWeiXin.selected == YES){
            [self doWeChatPay];//微信支付
        }
    }
}
#pragma mark 微信支付
-(void)doWeChatPay{
//    WXApi
    [WXApiRequestHandler jumpToBizPay];
}
//-(void)

#pragma mark 支付宝支付
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
//    [WXApi handleOpenURL:@"" delegate:self];
    return resultStr;
}
- (void)doAlipayPay
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
    [params setObject:@"getAlipayInfo" forKey:FLAG];
    [params setObject:@"1" forKey:SERVER_INDEX];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [FuncPublic HideHud:hud animating:YES];
        NSDictionary *result = [responseObject objectForKey:@"datas"];
        NSString *appID = [result objectForKey:@"appID"];
        NSString *privateKey = [result objectForKey:@"RSA_PRIVATE"];
        if ([appID length] == 0 ||
            [privateKey length] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"缺少appId或者私钥。"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        /*
         *生成订单信息及签名
         */
        //将商品信息赋予AlixPayOrder的成员变量
        Order* order = [Order new];
        // NOTE: app_id设置
        order.app_id = appID;
        // NOTE: 支付接口名称
        order.method = @"alipay.trade.app.pay";
        // NOTE: 参数编码格式
        order.charset = @"utf-8";
        // NOTE: 当前时间点
        NSDateFormatter* formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        order.timestamp = [formatter stringFromDate:[NSDate date]];
        // NOTE: 支付版本
        order.version = @"1.0";
        order.notify_url = [NSString stringWithFormat:@"%@/%@",BASE_URL,@"servlet/AliPayServlet"];
        // NOTE: sign_type设置
        order.sign_type = @"RSA";
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.signUpLeRunId forKey:@"lerun_id"];
        [dic setObject:self.signUpUserTel forKey:@"user_telphone"];
        order.format = [FuncPublic DataTojsonString:dic];//报名者电话号码
        // NOTE: 商品数据
        order.biz_content = [BizContent new];
        order.biz_content.body = self.lerunOrder;
        order.biz_content.subject = @"卡乐体育-活动支付";
        order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
        order.biz_content.timeout_express = @"30m"; //超时时间设置
        order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f",[self.signUpPrice floatValue]]; //商品价格
        //将商品信息拼接成字符串
        NSString *orderInfo = [order orderInfoEncoded:NO];
        NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
        NSLog(@"orderSpec = %@",orderInfo);
        
        // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
        //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
        id<DataSigner> signer = CreateRSADataSigner(privateKey);
        NSString *signedString = [signer signString:orderInfo];
        
        // NOTE: 如果加签成功，则继续执行支付
        if (signedString != nil) {
            //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
            NSString *appScheme = @"jxlerunapp";
            
            // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                     orderInfoEncoded, signedString];
            
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                //            NSLog(@"reslut = %@",resultDic);
            }];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FuncPublic HideHud:hud animating:YES];
        [WToast showWithText:HTTP_FAIL];
    }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
