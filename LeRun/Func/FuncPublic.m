//
//  FuncPublic.m
//  xUtilsDemo
//
//  Created by 彭雄辉的Mac Pro on 16/4/6.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//



#import "FuncPublic.h"
#import <ShareSDK/ShareSDK.h>
@interface FuncPublic()

@end

@implementation FuncPublic

+(NSString *)createUUID{
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidObject));
    CFRelease(uuidObject);
    return uuidStr;
}
+(NSString *)getUUID{
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}
+(CGRect)GetScreen{
    return [[UIScreen mainScreen] bounds];
}
/*
 *name:文件名
 *ect:后缀
 */
+(UIImage *)CreateImageFromFile:(NSString *)name ofType:(NSString *)ect{
    if([ect isEqualToString:@"jpg"]){
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:ect]];
        return image;
    }
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@.%@",name,ect]];
}
/*
 *str alert显示文字
 *vc 显示在哪个ViewController，一般为self
 *点击确定按钮之后的block
 */
+(void)ShowAlert:(NSString *)str ViewController:(UIViewController *)vc action:(void (^)())confirm
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if(confirm){
            confirm();
        }
    }];
    [alertController addAction:cancelAction];
    [vc presentViewController:alertController animated:YES completion:nil];
}
/*
 *str 提示详细文字
 *title title
 *vc 显示的ViewController
 *confirm 确定按钮
 *cancelAction 取消按钮
 *endAction alert显示之后的操作
 */
+(void)ShowAlert:(NSString *)str title:(NSString *)title ViewController:(UIViewController *)vc action:(void (^)())confirm cancelAction:(void (^)())cancelAction showEndAction:(void (^)())endAction{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(confirm){
            confirm();
        }
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if(cancelAction){
            cancelAction();
        }
    }];
    [alertController addAction:alertAction];
    [alertController addAction:alertCancel];
    [vc presentViewController:alertController animated:YES completion:^{
        if(endAction){
            endAction();
        }
    }];
}
#pragma mark HUD & Toast
/**HUD加载到Window上
 * delegate代理方法
 * label:text
 */
+(MBProgressHUD *)ShowHUDWithLabel:(id<MBProgressHUDDelegate>)delegateView Label:(NSString *)label{
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:appdelegate.window];
    hud.mode = MBProgressHUDModeCustomView;
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud setUserInteractionEnabled:YES];
    [appdelegate.window addSubview:hud];
    hud.delegate = delegateView;
    if(label != nil && label.length > 0){
        hud.labelText = label;
    }else{
        hud.labelText = @"正在加载";
    }
    [hud show:YES];
    return hud;
}
/*HUD加载到View上
 *delegateView 代理
 *parentView 加载到哪里
 *labe 显示什么字
 */
+(MBProgressHUD *)ShowHudWithLabel:(id<MBProgressHUDDelegate>)delegateView parentView:(UIView *)view Label:(NSString *)label{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:view];
    hud.mode = MBProgressHUDModeCustomView;
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud setUserInteractionEnabled:YES];
    [view addSubview:hud];
    hud.delegate = delegateView;
    if(label != nil && label.length >0){
        hud.labelText = label;
    }else{
        hud.labelText = @"正在加载";
    }
    [hud show:YES];
    return hud;
}
/*显示HUD sec秒后关闭
 *delegateView 代理
 *view 父View
 *label 显示文字
 *sec 多少秒后消失
 */
+(void)ShowHUDWithLabel:(id<MBProgressHUDDelegate>)delegateView parentView:(UIView *)view Label:(NSString *)label hideAfterDelay:(NSTimeInterval)sec{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:view];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud setUserInteractionEnabled:YES];
    [view addSubview:hud];
    hud.delegate = delegateView;
    if(label != nil && label.length > 0){
        hud.labelText = label;
    }else{
        hud.labelText = @"正在加载";
    }
    [hud show:YES];
    [self HideHUD:hud afterDelay:sec animating:YES];
}
/* sec秒后关闭HUD */
+(void)HideHUD:(MBProgressHUD *)hud afterDelay:(NSTimeInterval)sec animating:(BOOL)flag{
    [hud removeFromSuperview];
    [hud hide:flag afterDelay:sec];
}
/* 直接关闭HUD */
+(void)HideHud:(MBProgressHUD *)hud animating:(BOOL)flag{
    [hud removeFromSuperview];
    [hud hide:flag];
}
+(void)showToast:(NSString *)str{
    [WToast showWithText:str];
}

#pragma mark 添加常用控件
+(UIView *)InstanceSimpleView:(CGRect)rect backgroundColor:(UIColor *)color addToView:(UIView *)parentView{
    UIView *view = [[UIView alloc]init];
    view.frame = rect;
    view.backgroundColor = color;
    view.userInteractionEnabled = YES;
    if(parentView){
        [parentView addSubview:view];
    }
    return view;
}
+(void)InstanceNavgationBar:(NSString *)title titleColor:(UIColor *)titleColor superClass:(UIViewController *)controll isleftBtn:(BOOL)isleftBtn leftaction:(SEL)leftaction leftImage:(NSString *)leftimage isrightBtn:(BOOL)isrightbtn rightaction:(SEL)rightaction rightimage:(NSString *)rightimage background:(UIColor *)color{//添加类似导航栏View
    //状态栏
    UIView *statusBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVW,StatusBar_H)];
    statusBarView.backgroundColor = color;
    [controll.view addSubview:statusBarView];
    //导航栏
    UIView *naviBarView = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBar_H, DEVW, Navi_H)];
    naviBarView.backgroundColor = color;
    [controll.view addSubview:naviBarView];
    
    if(title){
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DEVW, CGRectGetHeight(naviBarView.frame))];
        titleLabel.text = title;
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.textAlignment = 1;
        titleLabel.textColor = titleColor;
        [naviBarView addSubview:titleLabel];
    }
    if(isleftBtn){
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, 0, 150.0*Coefficient, CGRectGetHeight(naviBarView.frame));
        [leftBtn addTarget:controll action:leftaction forControlEvents:UIControlEventTouchUpInside];
        [naviBarView addSubview:leftBtn];
        [leftBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",leftimage]] forState:UIControlStateNormal];
    }
    if(isrightbtn){
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(DEVW - 150.0 * Coefficient, 0, 150.0 * Coefficient, CGRectGetHeight(naviBarView.frame));
        [rightBtn addTarget:controll action:rightaction forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",rightimage]] forState:UIControlStateNormal];
        [naviBarView addSubview:rightBtn];
    }
    
}
+(UILabel *)InstanceSimpleLabel:(NSString *)text Rect:(CGRect)rect addToView:(UIView *)parentView Font:(UIFont *)font andTextColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor Aligment:(int)alignment{//添加UILabel
    CGRect rects = CGRectMake(roundf(rect.origin.x), roundf(rect.origin.y), roundf(rect.size.width), rect.size.height);
    UILabel *label = [[UILabel alloc]initWithFrame:rects];
    label.text = text;
    label.font = font;
    label.textAlignment = alignment;
    label.textColor = textColor;
    label.backgroundColor = backgroundColor;
    label.numberOfLines = 0;
    [parentView addSubview:label];
    return label;
}
+(UIImageView *)InstanceSimpleImageView:(UIImage *)image Rect:(CGRect)Rect userInteractionEnabled:(BOOL)isEnabled alpha:(CGFloat)alpha addtoView:(UIView *)parentView andTag:(int)tag{
    UIImageView *imageView = [[UIImageView alloc]init];
    if(image != nil){
        imageView.image = image;
        [FuncPublic cutImage:imageView.image size:CGSizeMake(Rect.size.width, Rect.size.height)];
    }
    //优化实例控件的处理时间，不用渲染。
    imageView.opaque = YES;
    imageView.frame = Rect;
    if(tag != 0){
        imageView.tag = tag;
    }
    [parentView addSubview:imageView];
    return imageView;
}
+(UIImageView *)InstanceHeaderImageView:(UIImage *)image Rect:(CGRect)Rect alpha:(CGFloat)alpha addtoView:(UIView *)parentView andTag:(int)tag{
    UIImageView *imageView = [[UIImageView alloc]init];
    if(image != nil){
        imageView.image = image;
        [FuncPublic cutImage:imageView.image size:CGSizeMake(Rect.size.width, Rect.size.height)];
    }
    //优化实例控件的处理时间，不用渲染。
    imageView.opaque = YES;
    imageView.frame = Rect;
    if(tag != 0){
        imageView.tag = tag;
    }
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selecterHeaderImage)];
    [imageView addGestureRecognizer:tap];
    [parentView addSubview:imageView];
    return imageView;
}
+(UIButton *)InstanceSimpleBtn:(NSString *)title Rect:(CGRect)Rect addToView:(UIView *)parentView titleFont:(NSInteger)fontSize titleColor:(UIColor *)titlecolor background:(UIColor *)color target:(void (^)())block{
    UIButton *btn = [[UIButton alloc]initWithFrame:Rect];
    btn.userInteractionEnabled = YES;
    [btn setBackgroundColor:color];
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titlecolor forState:UIControlStateNormal];
    [parentView addSubview:btn];
    return btn;
}
+(NSString *)TimerIntervalToString:(NSString *)time formatter:(NSString *)formatter{
    NSTimeInterval leRunTimeInterval = [time doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:leRunTimeInterval];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = formatter;
    return [format stringFromDate:date];
}
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
    int house = (int)value / (24 * 3600)%3600;
    int day = (int)value / (24 * 3600);
    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"耗时%d天%d小时%d分%d秒",day,house,minute,second];
    }else if (day==0 && house != 0) {
        str = [NSString stringWithFormat:@"耗时%d小时%d分%d秒",house,minute,second];
    }else if (day== 0 && house== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"耗时%d分%d秒",minute,second];
    }else{
        str = [NSString stringWithFormat:@"耗时%d秒",second];
    }
    return str;
}


-(void)selecterHeaderImage{
    
}

+(void)addTap:(UIView *)view block:(void (^)())completion{
    view.userInteractionEnabled = YES;
    //    UITapGestureRecognizer *tap = [UITapGestureRecognizer alloc]initWithTarget:self action:<#(nullable SEL)#>
}
/*
 *  实例image
 *FileNmae:图片文件名
 *ect:图片后缀名
 *_rect:位置
 *target:父类
 *_index:tag
 *isAdption
 */

+(UIImageView *)InstanceImageView:(NSString *)FileName Ect:(NSString *)ect RECT:(CGRect)rect Target:(id)target andTag:(int)tag isAdption:(BOOL)isAdption{
    CGRect orginRect;
    if(isAdption){
        if(ISIPHONE6)
            orginRect = rect;
        else orginRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width/375*DEVW, rect.size.height/667*DEVH);
    }else orginRect = rect;
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[FuncPublic CreateImageFromFile:FileName ofType:ect]];
    [FuncPublic cutImage:imageView.image size:CGSizeMake(orginRect.size.width, orginRect.size.height)];
    imageView.frame = orginRect;
    if(tag){
        imageView.tag = tag;
    }
    [(UIView *)target addSubview:imageView];
    return imageView;
}
+(UITextField *)InstanceTextField:(CGRect)rect andPlaceHolder:(NSString *)placeholder andTag:(int)tag addtoView:(UIView *)parentView andViewController:(UIViewController *)vc{
    UITextField *field = [[UITextField alloc]initWithFrame:rect];
    field.placeholder = placeholder;
    field.tag = tag;
    [parentView addSubview:field];
    field.returnKeyType = UIReturnKeyDone;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    return field;
}
+(UITableView *)InstanceTableView:(CGRect)Rect style:(UITableViewStyle)style addToView:(UIView *)parentView parentVC:(UIViewController *)parentVC backgroundColor:(UIColor *)backgroundColor isScrollEnabled:(BOOL)isScrollEnabled isShowSeparatorStyle:(BOOL)isShowSeparatorStyle{
    UITableView *layoutTable = [[UITableView alloc]initWithFrame:Rect style:style];
    layoutTable.tableHeaderView = nil;
    if(isScrollEnabled == NO){
        layoutTable.scrollEnabled = NO;
    }else{
        layoutTable.scrollEnabled = YES;
    }
    layoutTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layoutTable.showsHorizontalScrollIndicator = NO;
    layoutTable.showsVerticalScrollIndicator = YES;
    layoutTable.backgroundColor = backgroundColor;
    if(isShowSeparatorStyle == NO){
        layoutTable.separatorStyle = UITableViewCellSeparatorStyleNone;//无分割线
    }else{
        layoutTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [layoutTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    }
    [parentView addSubview:layoutTable];
    return layoutTable;
}
//+ (UIScrollView *)InstanceSimpleScrollView:(CGRect)Rect scrollEnabled:(BOOL)scrollEnabled contentSize:(CGSize)contentSize addtoView:(UIView *)parentView
+(UIScrollView *)InstanceSimpleScrollView:(CGRect)Rect scrollEnabled:(BOOL)scrollEnabled contentSize:(CGSize)contentSize addToView:(UIView *)parentView
{
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:Rect];
    scrollview.scrollEnabled = scrollEnabled;
    scrollview.bounces = NO;
    scrollview.contentOffset = CGPointMake(0, 0);
    scrollview.pagingEnabled = YES;
    scrollview.contentSize = contentSize;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.showsVerticalScrollIndicator = NO;
    [parentView addSubview:scrollview];
    
    return scrollview;
}

#pragma mark 判断类型
+(BOOL)isPureInt:(NSString *)string{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
+(BOOL)isPureFloat:(NSString *)string{
    NSScanner *scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}
+(BOOL)isEmpty:(id)str{
    if(str == nil){
        return YES;
    }
    if(str == NULL){
        return YES;
    }
    if([str isKindOfClass:[NSNull class]]){
        return YES;
    }
    if([str isKindOfClass:[NSString class]] && [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
        return YES;
    }else{
        return NO;
    }
}
+ (BOOL)isNilOrEmpty:(NSString *)str {
    if (str == nil || [str length] == 0 || [str stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        return YES;
    }
    return NO;
}

#pragma mark 判断密码
//判断密码是否太简单。
+(BOOL)pwdIsSimple:(NSString *)str{
    NSString *allStr = allSimplePwdStr;
    if([allStr rangeOfString:str].location != NSNotFound){
        return YES;//找到了一样的，return yes;
    }else{
        return NO;
    }
}
//判断密码是否含有特殊字符
+(BOOL)pwdIsAb1:(NSString *)str{
    NSString *SpecialChar = SpecialCharPwdStr;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",SpecialChar];
    BOOL isMatch = [pred evaluateWithObject:str];
    return !isMatch;
}
//密码必须有字母和数字
+(BOOL)pwdMustHaveAb1:(NSString *)str{
    NSString *mustCharInt = MustCharIntPwdStr;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mustCharInt];
    BOOL isMatch = [pred evaluateWithObject:str];
    return !isMatch;
}

#pragma mark 网络访问相关
//+(void)requestPost:(NSDictionary *)requestParams requestDelegate:(id<RequestDelegate>)requestDelegate requestUrl:(NSString *)url target:(NSString *)target{
//    AFHTTPSessionManager *manager = [FuncPublic getAFNetManager];
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    manager.requestSerializer.timeoutInterval = 20;
//    [manager POST:url parameters:requestParams success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        if([target isEqualToString:@"dic"] || [target isEqualToString:@"dic1"] || [target isEqualToString:@"dic2"] || [target isEqualToString:@"dic3"] || [target isEqualToString:@"dic4"] || [target isEqualToString:@"dic5"]){
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            [requestDelegate responseDic:dict target:target];
//        }else if(requestDelegate){
//            [requestDelegate responseResult:operation.responseString target:target];
//        }
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        NSLog(@"请求失败.....错位代码为:%@",error);
//    }];
//}
+(AFHTTPRequestOperationManager *)getAFNetManager{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"Authorization"];
    //申请返回类型为data
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20;
    return manager;
}
+(AFHTTPRequestOperationManager *)getAFNetJSONManager{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"Authorization"];
    //申请返回类型为data
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20;
    return manager;
}

+(NSString *)checkNetwork:(NSString *)url{
    NSString *host = url;
    if([FuncPublic isNilOrEmpty:url]){
        host = @"www.baidu.com";
    }
    Reachability *r = [Reachability reachabilityWithHostName:host];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            NSLog(@"没有网络");
            return NETWORK_UNAVAILABLE;
            break;
        case ReachableViaWWAN:
            NSLog(@"3G网络");
            return NETWORK_3G;
        case ReachableViaWiFi:
            NSLog(@"正在使用WIFI网络");
            return NETWORK_WIFI;
        default:
            break;
    }
}
+(void)cleanCache:(NSString *)alert delegate:(id)delegate tureButtonTitle:(NSString *)tureButtonTitle cancelButtonTitles:(NSString *)cancelButtonTitles{
    //    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    [appdelegate.manager.requestSerializer setValue:@"" forHTTPHeaderField:@"Authorization"];
    //
    //    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    //    NSDictionary *dic = [defs dictionaryRepresentation];
    //    for (id key in dic)
    //    {
    //        NSString *string = (NSString *)key;
    //        if ([string isEqualToString:@"username"])   //用户保存用户登录名
    //        {
    //            continue;
    //        }
    //        else if ([string isEqualToString:@"ActivityDetails"])   //用户保存浏览记录
    //        {
    //            continue;
    //        }
    //
    //        [defs removeObjectForKey:key];
    //    }
    //    [defs synchronize];
    //
    //    if (alert != nil)
    //    {
    //        [MyUtils showAlertString:nil Message:alert delegate:delegate tureButtonTitle:tureButtonTitle cancelButtonTitles:cancelButtonTitles];
    //    }
}




#pragma mark utils
+(UIImage *)cutImage:(UIImage *)image size:(CGSize)size{
    CGSize newSize;
    CGImageRef imageRef = nil;
    if((image.size.width/image.size.height)<(size.width/size.height)){//图片的宽/高 < 需要的宽/高
        newSize.width = image.size.width;
        newSize.height = image.size.width * size.height / size.width;
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height)/2, newSize.width, newSize.height));
    }else{
        newSize.height = image.size.height;
        newSize.width = image.size.height * size.width/size.height;
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width)/2,0, newSize.width, newSize.height));
    }
    UIImage *images = [UIImage imageWithCGImage:imageRef];
    //防止内存泄露
    CGImageRelease(imageRef);
    return images;
}

+(float)GetHeightFromString:(NSString *)text Font:(UIFont *)font Width:(float)width{//计算高度
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    if(size.height > roundf(size.height)){
        return roundf(size.height) + 1;
    }else{
        return roundf(size.height);
    }
}

+(float)GetWidthFromString:(NSString *)text Font:(UIFont *)font Height:(float)height{//计算宽度
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    if(size.width > roundf(size.width)){
        return roundf(size.width) + 1;
    }else{
        return roundf(size.width);
    }
}
/*计算字符串的尺寸
 *width 字符串宽度
 *height 字符串高度
 */
+(CGSize)checkSizeFromString:(NSString *)text Font:(UIFont *)font Width:(float)width Height:(float)height{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return size;
}


#pragma mark data
+(void)SaveDefaultInfo:(id)str Key:(NSString *)key{
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    [standardUserDefault setValue:str forKey:key];
    [standardUserDefault synchronize];
}
+(id)GetDefaultInfo:(NSString *)key{
    id temp = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if(temp == nil){
        return nil;
    }
    return temp;
}
+(void)RemoveDefaultbyKey:(NSString *)key{
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    [standardUserDefault removeObjectForKey:key];
    [standardUserDefault synchronize];
}
/*保存对象到文件夹中
 * obj 对象 name 文件夹地址
 */
+(NSString *)saveObjToFile:(id)obj fileName:(NSString *)name{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *fileName = [path stringByAppendingPathComponent:name];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];//将obj序列化后保存到NSData中
    [data writeToFile:fileName atomically:YES];//持久化保存成物理文件
    return path;
}
/* 保存对象到文件夹中
 * obj 对象
 * name filename
 * path file路径
 */
+(NSString *)saveObjToFile:(id)obj fileName:(NSString *)name path:(NSString *)path{
    NSString *filename = [path stringByAppendingString:name];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];//将obj序列化之后保存到NSData中
    [data writeToFile:filename atomically:YES];//持久化保存成为物理文件
    return path;
}
/* 根据path地质，获取对象
 * name
 */
+(id)getObjFromFile:(NSString *)name{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *fileName = [path stringByAppendingString:name];
    NSData *data = [NSData dataWithContentsOfFile:fileName];//读取文件
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];//反序列化
    return obj;
}
/*
 *save password in keychain
 */
+(void)savePwd:(NSString *)key data:(id)data{
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}
+ (id)getPwd:(NSString *)key {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", key, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)deletePwd:(NSString *)key {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)key {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            key, (id)kSecAttrService,
            key, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+(void)hideTabBar:(UIViewController *)vc{
    if (vc.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[vc.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
        contentView = [vc.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [vc.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + vc.tabBarController.tabBar.frame.size.height);
    vc.tabBarController.tabBar.hidden = YES;
}
+(void)showTabBar:(UIViewController *)vc
{
    if (vc.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    UIView *contentView;
    if ([[vc.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
        contentView = [vc.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [vc.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - vc.tabBarController.tabBar.frame.size.height);
    vc.tabBarController.tabBar.hidden = NO;
    
}
+(NSString *)randString:(NSInteger)length{
    NSArray *randArray = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"I",@"J",@"K",@"W",@"X",@"7",@"8",@"Y",@"Z",@"a",@"v",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"4",@"5",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"0",@"1",@"2",@"3",@"6",@"9"];
    NSString *resultStr = @"";
    for(int i = 0 ;i<length ;i++){
        resultStr = [randArray[arc4random()%62] stringByAppendingString:resultStr];
    }
    return resultStr;
}

+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/* 目前只支持中国电信，中国移动，中国联通 */
+(BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString *CU = @"^1(3[0-2]|5[256]|7[07]|8[56]|81)\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    //NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    //NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    //NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        //|| ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
+(void)shareWithShareMenuOnly:(UIViewController *)vc haveReport:(BOOL)tip
{
    //1、构造分享内容
    //1.1、要分享的图片（以下分别是网络图片和本地图片的生成方式的示例）
    id<ISSCAttachment> remoteAttachment = [ShareSDKCoreService attachmentWithUrl:@"http://imgsrc.baidu.com/forum/w%3D580/sign=e2bb92723e7adab43dd01b4bbbd5b36b/e9c17446f21fbe0971c1e24e63600c338644add3.jpg"];
    //    id<ISSCAttachment> localAttachment = [ShareSDKCoreService attachmentWithPath:[[NSBundle mainBundle] pathForResource:@"shareImg" ofType:@"png"]];
    //1.2、以下参数分别对应：内容、默认内容、图片、标题、链接、描述、分享类型
    id<ISSContent> publishContent = [ShareSDK content:@"跟我一起来卡乐彩色跑玩吧 http://wwwjxkuafu.com"
                                       defaultContent:nil
                                                image:remoteAttachment
                                                title:@"卡乐彩色跑"
                                                  url:@"http://www.jxkuafu.com"
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //1.3、自定义各个平台的分享内容(非必要)
    [FuncPublic customizePlatformShareContent:publishContent];
    
    //1+、创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:vc.view arrowDirect:UIPopoverArrowDirectionUp];
    
    //自定义新浪微博分享菜单项，
    id<ISSShareActionSheetItem> sinaItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo] icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]clickHandler:^{
        [ShareSDK shareContent:publishContent
                          type:ShareTypeSinaWeibo
                   authOptions:nil statusBarTips:YES  result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                       NSLog(@"=== response state :%zi ",state);
                       //可以根据回调提示用户。
                       if (state == SSResponseStateSuccess)
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:self                                cancelButtonTitle:@"OK"                                                           otherButtonTitles:nil, nil];
                           [alert show];
                       }
                       else if (state == SSResponseStateFail){
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"                               message:[NSString stringWithFormat:@"错误信息：%@",[error errorDescription]]                                                               delegate:self cancelButtonTitle:@"OK"                                              otherButtonTitles:nil, nil];
                           [alert show];
                       }
                   }];
    }];
    id<ISSShareActionSheetItem> report = [ShareSDK shareActionSheetItemWithTitle:@"举报" icon:[UIImage imageNamed:@"inform.png"] clickHandler:^{
        [WToast showWithText:@"举报成功"];
    }];
    //自定义QQ空间分享菜单项
    id<ISSShareActionSheetItem> qzoneItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeQQSpace] icon:[ShareSDK getClientIconWithType:ShareTypeQQSpace]clickHandler:^{
        [ShareSDK shareContent:publishContent type:ShareTypeQQSpace authOptions:nil statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
            NSLog(@"=== response state :%zi ",state);
            //可以根据回调提示用户。
            if (state == SSResponseStateSuccess)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:nil                                                                    delegate:self cancelButtonTitle:@"OK"                                                      otherButtonTitles:nil, nil]; [alert show];
            }
            else if (state == SSResponseStateFail)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"                                                  message:[NSString stringWithFormat:@"Error Description：%@",[error errorDescription]]                                                                                                            delegate:self                                                                                   cancelButtonTitle:@"OK"                                                                                        otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }];
    //创建自定义分享列表
    NSMutableArray *shareList = (NSMutableArray *)[ShareSDK customShareListWithType:
//                          sinaItem,  //由于没有申请APP key 暂时停用
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          SHARE_TYPE_NUMBER(ShareTypeQQ),
                          qzoneItem,
                          SHARE_TYPE_NUMBER(ShareTypeMail),
                          SHARE_TYPE_NUMBER(ShareTypeSMS),
                          SHARE_TYPE_NUMBER(ShareTypeCopy),
                          nil];
    if(tip){//如果需要举报功能，那么加上
        [shareList addObject:report];
    }
    
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                NSLog(@"=== response state :%zi ",state);
                                //可以根据回调提示用户。
                                if (state == SSResponseStateSuccess)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:[NSString stringWithFormat:@"Error Description：%@",[error errorDescription]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                            }];
}
+(void)customizePlatformShareContent:(id<ISSContent>)publishContent
{
    //定制QQ空间分享内容
    [publishContent addQQSpaceUnitWithTitle:@"title卡乐彩色跑"
                                        url:@"http://www.jxkuafu.com"
                                       site:nil
                                    fromUrl:nil
                                    comment:@"comment"
                                    summary:@"卡乐彩色跑"
                                      image:[ShareSDKCoreService attachmentWithUrl:@"http://imgsrc.baidu.com/forum/w%3D580/sign=e2bb92723e7adab43dd01b4bbbd5b36b/e9c17446f21fbe0971c1e24e63600c338644add3.jpg"]//图片
                                       type:@(4)
                                    playUrl:nil
                                       nswb:0];
    //定制邮件分享内容
    [publishContent addMailUnitWithSubject:@"我在彩色卡了跑"
                                   content:@"和我一起来参与彩色卡乐跑吧！http://www.jxkuafu.com"
                                    isHTML:[NSNumber numberWithBool:YES]
                               attachments:nil
                                        to:nil
                                        cc:nil
                                       bcc:nil];
    //定制新浪微博分享内容
    id<ISSCAttachment> localAttachment = [ShareSDKCoreService attachmentWithPath:[[NSBundle mainBundle] pathForResource:@"shareImg" ofType:@"png"]];
    [publishContent addSinaWeiboUnitWithContent:@"The content of Sina Weibo" image:localAttachment];
}


+(NSString*)DataTojsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
+(UIViewController *)parentViewController:(UIView *)parentView{
    for (UIView* next = [parentView superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
@end
