//
//  AppDelegate.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/4.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "AppDelegate.h"
#import "RunViewController.h"
#import "ShowViewController.h"
#import "HistoryViewController.h"
#import "MeViewController.h"
#import "WelcomeViewController.h"
#import "AdvertViewController.h"
#import "UIImageView+WebCache.h"
#import <SMS_SDK/SMSSDK.h>//短信
#import <AlipaySDK/AlipaySDK.h>
//分享
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "WXApiManager.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initShare];
    
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];//状态栏白色字。
    if([[FuncPublic GetDefaultInfo:FIRST_LOGIN] isEqualToString:@"1"]){//已经登录过
        AFHTTPRequestOperationManager *manager = [FuncPublic getAFNetManager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 3;
        [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,ADIMAGE] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            AdvertViewController *aVC = [AdvertViewController new];
            aVC.image = [UIImage imageWithData:responseObject];
            [self.window setRootViewController:aVC];
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *tab = [mainStory instantiateViewControllerWithIdentifier:@"tabBarController"];
            tab.selectedIndex = -1;
            [tab.tabBar setTintColor:RGBCOLOR(0x00, 0xbb, 0x9c)];
            self.window.rootViewController = tab;
        }];
    }else{//没有登录过
        WelcomeViewController *wVC = [WelcomeViewController new];
        self.window.rootViewController = wVC;
    }
    [self.window makeKeyAndVisible];
    return YES;
}
//-(void)remove:(UIImageView *)imageView {
//    [imageView removeFromSuperview];
//}
-(void)initShare{
    //短信验证
    [SMSSDK registerApp:@"1580ed2533d9b" withSecret:@"34fabd64cfa020e14f7f5cca89b4ae46"];
    //分享
    [ShareSDK registerApp:@"158ace2241966"];
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    
    //没有申请微博ID，暂时不使用。
//    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
//                        appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                             redirectUri:@"http://www.sharesdk.cn"
//                             weiboSDKCls:[WeiboSDK class]];
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     **/
    //    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
    //                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
    //                                redirectUri:@"http://www.sharesdk.cn"];
    
    //连接短信分享
    [ShareSDK connectSMS];
    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                        appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
//    wxd53a85d9d28402bf
    [ShareSDK connectWeChatWithAppId:@"wxb4ba3c02aa476ea1" wechatCls:[WXApi class]];
    //qq空间分享
    [ShareSDK connectWeChatWithAppId:@"wxb10697c309db8491" appSecret:@"3a2a7df6e08b2aee7954dcb74494f490"
                           wechatCls:[WXApi class]];
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    //qq聊天分享，没有显示app名字
    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //连接邮件
    [ShareSDK connectMail];
    
    //连接打印
    [ShareSDK connectAirPrint];
    
    //连接拷贝
    [ShareSDK connectCopy];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    NSLog(@"-=-%@",[url absoluteString]);
//    if ([[url absoluteString] hasPrefix:@"wechat"])
//    {
//        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
//    }
    if([url.host isEqualToString:@"pay"]){
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]){//支付成功
                [WToast showWithText:@"支付成功"];
                //发送付款成功通知
                NSNotification *notice = [NSNotification notificationWithName:@"paySuccess" object:nil userInfo:resultDic];
                [[NSNotificationCenter defaultCenter] postNotification:notice];
            }else{
                [WToast showWithText:@"支付失败"];
            }
        }];
    }
    return YES;
}

@end
