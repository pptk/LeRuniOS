//
//  SendViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/20.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "SendViewController.h"
#import "DFPickerNav.h"
#import "DFPickerVC.h"
#import "GBAvatarBrowser.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#define INPUT_SIZE 140

@interface SendViewController ()<DFPickerDelegate>
{
    NSMutableArray *imageArray;
}
@end

@implementation SendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [FuncPublic hideTabBar:self];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.inputTextView.layer.cornerRadius = 4;
    self.inputTextView.layer.masksToBounds = YES;
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(sendAction:)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    [self kvoInputTextView];
}
#pragma mark 发表
-(void)sendAction:(id)sender{
    NSString *str = [self.inputTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(![[FuncPublic GetDefaultInfo:IS_LOGIN] isEqualToString:@"true"]){//如果还没有登录
        [WToast showWithText:NO_LOGIN];
        return;
    }
    if(imageArray.count == 0 && str.length == 0){//如果没有内容
        [WToast showWithText:SETNULL];
        return;
    }
    NSMutableArray *imageDataArray = [NSMutableArray array];
    if(imageArray.count>0){
        for(id object in imageArray){
            UIImage *image = [object objectForKey:@"UIImagePickerControllerMediaType"];
            NSData *dd = UIImageJPEGRepresentation(image, 0.000001);
            [imageDataArray addObject:dd];
        }
    }else{
        MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
        [self postShow:@"" hub:hud];
        return;
    }
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    AFHTTPRequestOperationManager *manager = [FuncPublic getAFNetManager];
    [manager setSecurityPolicy:securityPolicy];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
    [manager POST:UPLOAD_IMAGE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for(int i = 0;i<imageDataArray.count;i++){
            NSString *name = [FuncPublic randString:12];
            [formData appendPartWithFileData:imageDataArray[i] name:[NSString stringWithFormat:@"img%d%@",i,name] fileName:[NSString stringWithFormat:@"img%d%@.jpg",i,name] mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *result = responseObject;
        NSDictionary *imageDic = [result objectForKey:@"datas"];
        NSString *imageStr = [FuncPublic DataTojsonString:imageDic];
        int k = [[result objectForKey:@"state"] intValue];
        if(k == 1){
            [self postShow:imageStr hub:hud];
        }else{
            [FuncPublic HideHud:hud animating:YES];
            [WToast showWithText:HTTP_FAIL];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FuncPublic HideHud:hud animating:YES];
        [WToast showWithText:HTTP_FAIL];
    }];
    
}
-(void)postShow:(NSString *)imageStr hub:(MBProgressHUD *)hud{
    if([FuncPublic isNilOrEmpty:[FuncPublic GetDefaultInfo:USER_ID]]){
        [WToast showWithText:NO_LOGIN];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"show" forKey:FLAG];
    [params setValue:@"0" forKey:SERVER_INDEX];
    [params setValue:[FuncPublic GetDefaultInfo:USER_ID] forKey:@"user_id"];
    [params setValue:self.inputTextView.text forKey:@"show_content"];
    [params setValue:imageStr forKey:@"show_image"];
    [[FuncPublic getAFNetManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData *data = (NSData *)responseObject;
        NSString *state = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if([state isEqualToString:@"1"]){
            [FuncPublic HideHud:hud animating:YES];
            [WToast showWithText:SUCCESS];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [FuncPublic HideHud:hud animating:YES];
            [WToast showWithText:HTTP_FAIL];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FuncPublic HideHud:hud animating:YES];
        [WToast showWithText:HTTP_FAIL];
    }];
}
#pragma mark 限制字数
-(void)kvoInputTextView{
    RACSignal *validInputSignal = [self.inputTextView.rac_textSignal map:^id(NSString *value) {
        return @([self isValidInput:value]);
    }];
    
    RAC(self.inputTextView,backgroundColor) = [validInputSignal map:^id(NSString *value) {
        if([value boolValue]){
            self.inputTextView.text = [self.inputTextView.text substringWithRange:NSMakeRange(0, INPUT_SIZE)];
            self.inputSize.text = [NSString stringWithFormat:@"%ld/%d",self.inputTextView.text.length,INPUT_SIZE];
            self.inputSize.textColor = [UIColor redColor];
            return [UIColor whiteColor];
        }else{
            self.inputSize.text = [NSString stringWithFormat:@"%ld/%d",self.inputTextView.text.length,INPUT_SIZE];
            self.inputSize.textColor = [UIColor blackColor];
            return [UIColor whiteColor];
        }
    }];
    
}
-(BOOL)isValidInput:(NSString *)str{
    if(str.length > INPUT_SIZE){
        return YES;
    }
    return NO;
}
#pragma mark 选择图片
- (IBAction)selectedImage:(id)sender {
    DFPickerVC *picVC = [DFPickerVC new];
    DFPickerNav *picNav= [[DFPickerNav alloc]initWithRootViewController:picVC];
    picVC.parent = picNav;
    picNav.Mydelegate = self;
    [self presentViewController:picNav animated:YES completion:nil];
}
#pragma mark 代理方法
-(void)dfPickerNav:(DFPickerNav *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    for(UIView *view in self.selectedBackground.subviews){
        [view removeFromSuperview];
    }
    imageArray = [NSMutableArray arrayWithArray:info];
    [self createSelectedImageView:info];
}
-(void)createSelectedImageView:(NSArray *)array{
    int i = 0;
    for (id object in array) {
        GBAvatarBrowser *imageView = [[GBAvatarBrowser alloc]initWithFrame:CGRectMake(((60+10)*i), 0, 60, 60)];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [object objectForKey:@"UIImagePickerControllerMediaType"];
        imageView.clipsToBounds = YES;
        [self.selectedBackground addSubview:imageView];
        i++;
    }
    if(self.selectedBackground.subviews.count < 3){
        UIImageView *imageViewLast = [[UIImageView alloc]initWithFrame:CGRectMake((60+10)*i, 0, 60, 60)];
        imageViewLast.image = [UIImage imageNamed:@"add_image.png"];
        imageViewLast.contentMode = UIViewContentModeScaleAspectFill;
        imageViewLast.userInteractionEnabled = YES;//可以点击
        imageViewLast.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedImage:)];
        [imageViewLast addGestureRecognizer:tap];
        [self.selectedBackground addSubview:imageViewLast];//添加到视图上。
    }
}
-(void)dfPickerNavDidCancel:(DFPickerNav *)picker{
    NSLog(@"选择了取消!");
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
