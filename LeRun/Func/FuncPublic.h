//
//  FuncPublic.h
//  xUtilsDemo
//
//  Created by 彭雄辉的Mac Pro on 16/4/6.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

//@weakify和@strongify。方便使用block的时候使用。
#define URLSTART @""


#ifndef    weakify
#if __has_feature(objc_arc)

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#else

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \
_Pragma("clang diagnostic pop")

#endif
#endif

#ifndef    strongify
#if __has_feature(objc_arc)

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")

#else

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __block_##x##__; \
_Pragma("clang diagnostic pop")

#endif
#endif







#define allSimplePwdStr @"000000、111111、11111111、112233、123123、123321、123456、12345678、654321、666666、888888、abcdef、abcabc、abc123、a1b2c3、aaa111、123qwe、qwerty、qweasd、admin、password、p@ssword、passwd、iloveyou、5201314，password、123456、12345678、qwerty、abc123、monkey、1234567、letmein、trustno1、dragon、baseball、111111、iloveyou、master、sunshine、ashley、bailey、passw0rd、shadow、123123、654321、superman、qazwsx、michael、football"
#define SpecialCharPwdStr @"^[a-zA-Z0-9]$"
#define MustCharIntPwdStr @"^(?![0-9]+$)(?![a-z]+$)(?![A-Z]+$)[0-9A-Za-z]{6,16}$"

#define DEVW [UIScreen mainScreen].bounds.size.width
#define DEVH [UIScreen mainScreen].bounds.size.height

#define StatusBar_H 20
#define Navi_H 44
#define Coefficient ([[UIScreen mainScreen] bounds].size.width / 1080)
#define BOTTOM_H 44

//#define RGB(r,g,b,a) [UIColor colorWithRed:r/255%255.0 green:g/255%255.0 blue:b/255%255.0 alpha:a]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#pragma mark - 设备版本
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_6 [[[UIDevice currentDevice] systemVersion] floatValue] == 6
#define IS_IPHONE_7 [[[UIDevice currentDevice] systemVersion] floatValue] == 7
#define IS_IPHONE_8 [[[UIDevice currentDevice] systemVersion] floatValue] == 8
#define ISIPHONE4 DEVH==480
#define ISIPHONE5 DEVH==568
#define ISIPHONE6 DEVW==375
#define ISIPHONE6_PLUS DEVW>400

#define NETWORK_UNAVAILABLE @"1"
#define NETWORK_3G @"2"
#define NETWORK_WIFI @"3"

#define NAVBARCOLOR RGBCOLOR(12,181,245)

#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "NSString+MD5.h"
#import <Security/Security.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WToast.h"

@protocol RequestDelegate <NSObject>

-(void)responseResult:(NSString *)content target:(NSString *)target;
-(void)responseDic:(NSDictionary *)content target:(NSString *)target;

@end

//.h文件中药使用MBProgressHUDDelegate & MBProgressHUD必须先引入。
@protocol MBProgressHUDDelegate;
@class MBProgressHUD;

@interface FuncPublic : NSObject

+(NSString *)getUUID;
+(NSString *)createUUID;

#pragma mark alert
+(CGRect)GetScreen;//获取机型宽高
+(UIImage *)CreateImageFromFile:(NSString *)name ofType:(NSString *)ect;//生成图片
+(void)ShowAlert:(NSString *)str ViewController:(UIViewController *)vc action:(void (^)())confirm;//Alert 单独提示,只有确定按钮
+(void)ShowAlert:(NSString *)str title:(NSString *)title ViewController:(UIViewController *)vc action:(void (^)())confirm cancelAction:(void(^)())cancelAction showEndAction:(void(^)())endAction;//确定和取消操作。

#pragma mark MBProgressHUD
+(MBProgressHUD *)ShowHUDWithLabel:(id<MBProgressHUDDelegate>)delegateView Label:(NSString *)label;//显示HUD在Windows上。
+(MBProgressHUD *)ShowHudWithLabel:(id<MBProgressHUDDelegate>)delegateView parentView:(UIView *)view Label:(NSString *)label;//添加HUD到View上。
+(void)ShowHUDWithLabel:(id<MBProgressHUDDelegate>)delegateView parentView:(UIView *)view Label:(NSString *)label hideAfterDelay:(NSTimeInterval)sec;//显示sec秒后消失
+(void)HideHUD:(MBProgressHUD *)hud afterDelay:(NSTimeInterval)sec animating:(BOOL)flag;//多少秒后关闭
+(void)HideHud:(MBProgressHUD *)hud animating:(BOOL)flag;//直接关闭
+(void)showToast:(NSString *)str;


#pragma mark 添加常用控件
+(UIView *)InstanceSimpleView:(CGRect)rect backgroundColor:(UIColor *)color addToView:(UIView *)parentView;
+(void)InstanceNavgationBar:(NSString *)title titleColor:(UIColor *)titleColor superClass:(UIViewController *)controll isleftBtn:(BOOL)isleftBtn leftaction:(SEL)leftaction leftImage:(NSString *)leftimage isrightBtn:(BOOL)isrightbtn rightaction:(SEL)rightaction rightimage:(NSString *)rightimage background:(UIColor *)color;//添加类似导航条
+(UILabel *)InstanceSimpleLabel:(NSString *)text Rect:(CGRect)rect addToView:(UIView *)parentView Font:(UIFont *)font andTextColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor Aligment:(int)alignment;//添加UILabel
+(UIImageView *)InstanceSimpleImageView:(UIImage *)image Rect:(CGRect)Rect userInteractionEnabled:(BOOL)isEnabled alpha:(CGFloat)alpha addtoView:(UIView *)parentView andTag:(int)tag;//添加图片
+(UIImageView *)InstanceImageView:(NSString *)FileName Ect:(NSString *)ect RECT:(CGRect)rect Target:(id)target andTag:(int)tag isAdption:(BOOL)isAdption;//添加图片
+(UITextField *)InstanceTextField:(CGRect)rect andPlaceHolder:(NSString *)placeholder andTag:(int)tag addtoView:(UIView *)parentView andViewController:(UIViewController *)vc;//add TextField
+(UITableView *)InstanceTableView:(CGRect)Rect style:(UITableViewStyle)style addToView:(UIView *)parentView parentVC:(UIViewController *)parentVC backgroundColor:(UIColor *)backgroundColor isScrollEnabled:(BOOL)isScrollEnabled isShowSeparatorStyle:(BOOL)isShowSeparatorStyle;//add tableView
+(UIScrollView *)InstanceSimpleScrollView:(CGRect)Rect scrollEnabled:(BOOL)scrollEnabled contentSize:(CGSize)contentSize addToView:(UIView *)parentView;//add scrollView
+(UIImageView *)InstanceHeaderImageView:(UIImage *)image Rect:(CGRect)Rect alpha:(CGFloat)alpha addtoView:(UIView *)parentView andTag:(int)tag;//添加头像图片
+(UIButton *)InstanceSimpleBtn:(NSString *)title Rect:(CGRect)Rect addToView:(UIView *)parentView titleFont:(NSInteger)fontSize titleColor:(UIColor *)titlecolor background:(UIColor *)color target:(void(^)())block;
+(void)addTap:(UIView *)view block:(void (^)())completion;

#pragma mark 类型相关判断
+(BOOL)isPureInt:(NSString *)string;//判断NSString是否为整形
+(BOOL)isPureFloat:(NSString *)string;//判断NSString是否为浮点型
+(BOOL)isEmpty:(id)str;//判断对象是否为空
+(BOOL)isNilOrEmpty:(NSString *)str;

#pragma mark 密码判断
+(BOOL)pwdIsSimple:(NSString *)str;//判断密码是否过于简单
+(BOOL)pwdIsAb1:(NSString *)str;//判断是否包含特殊字符(必须是大小写字母和数字)
+(BOOL)pwdMustHaveAb1:(NSString *)str;//必须包含大小写字母或者数字中两种


#pragma mark AFNetworking 网络
+(void)requestPost:(NSDictionary *)requestParams requestDelegate:(id<RequestDelegate>)requestDelegate requestUrl:(NSString *)url target:(NSString *)target;//requestParams:请求参数 requestDelegate:实现RequestDelegate代理 requestUrl:请求地址 target:回调标识，用于回调处理返回结果
+(AFHTTPRequestOperationManager *)getAFNetManager;
+(NSString *)checkNetwork:(NSString *)url;//判断网络类型
+(void)cleanCache:(NSString *)alert delegate:(id)delegate tureButtonTitle:(NSString *)tureButtonTitle cancelButtonTitles:(NSString *)cancelButtonTitles;//清除缓存

#pragma mark utils
+(UIImage *)cutImage:(UIImage *)image size:(CGSize)size;//剪切图片
+(float)GetWidthFromString:(NSString *)text Font:(UIFont *)font Height:(float)height;//通过字符串和字体、高度计算最后宽度。
+(float)GetHeightFromString:(NSString *)text Font:(UIFont *)font Width:(float)width;//根据字符串和字体、宽度计算最后高度。
+(CGSize)checkSizeFromString:(NSString *)text Font:(UIFont *)font Width:(float)width Height:(float)height;//计算字符串尺寸

#pragma mark data
+(void)SaveDefaultInfo:(id)str Key:(NSString *)key;
+(id)GetDefaultInfo:(NSString *)key;

+(NSString *)saveObjToFile:(id)obj fileName:(NSString *)name;//保存到文件夹
+(NSString *)saveObjToFile:(id)obj fileName:(NSString *)name path:(NSString *)path;//保存到指定位置文件夹
+(id)getObjFromFile:(NSString *)name;//从文件夹获取Obj

//在keyChain中保存账号密码等。
+(void)savePwd:(NSString *)key data:(id)data;//保存密码
+(id)getPwd:(NSString *)key;//获取
+(void)deletePwd:(NSString *)key;//删除
@end
















