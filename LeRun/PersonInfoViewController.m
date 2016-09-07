//
//  PersonInfoViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/21.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//  1、聚焦聚焦再聚焦。 2、

#import "PersonInfoViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIImageView+WebCache.h"
@interface PersonInfoViewController ()
@property(strong,nonatomic)UIAlertController *alertController;
@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [FuncPublic hideTabBar:self];
    self.navigationItem.title = @"个人资料";
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    
    self.userID = [FuncPublic GetDefaultInfo:@"USER_ID"];
    [self getData:self.userID];
    [self addTap];
}
-(void)getData:(NSString *)userid{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"user" forKey:FLAG];
    [params setValue:@"4" forKey:SERVER_INDEX];
    [params setValue:userid forKey:@"user_id"];
    
    MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *result = [responseObject objectForKey:@"result"];
        if([[result objectForKey:@"user_header"] isEqualToString:@""]){
            self.headerImageView.image = [UIImage imageNamed:@"default_avtar.jpg"];
        }else{
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",BASE_URL,[result objectForKey:@"user_header"]]] placeholderImage:[UIImage imageNamed:@"default_avtar.jpg"]];
            [FuncPublic RemoveDefaultbyKey:USER_HEADER];
            NSData *data = UIImageJPEGRepresentation(self.headerImageView.image, 0.0001);
            [FuncPublic SaveDefaultInfo:data Key:USER_HEADER];
        }
        if(![[result objectForKey:@"user_name"]isEqualToString:@""]){
            [FuncPublic RemoveDefaultbyKey:USER_NAME];
            [FuncPublic SaveDefaultInfo:[result objectForKey:@"user_name"] Key:USER_NAME];
        }
        self.nickNameText.text = ![[result objectForKey:@"user_name"]isEqualToString:@""]?[result objectForKey:@"user_name"]:@"佚名";
        self.telPhoneText.text = ![[result objectForKey:@"user_phone"]isEqualToString:@""]?[result objectForKey:@"user_phone"]:@"18270839435";
        self.emailText.text = ![[result objectForKey:@"user_email"]isEqualToString:@""]?[result objectForKey:@"user_email"]:@"123@qq.com";
        if([[result objectForKey:@"user_sex"] isEqualToString:@"男"]){
            self.boyBtn.selected = YES;
        }else if ([[result objectForKey:@"user_sex"] isEqualToString:@"女"]){
            self.girlBtn.selected = YES;
        }
        self.heightText.text = ![[result objectForKey:@"user_height"] isEqualToString:@""]?[result objectForKey:@"user_height"]:@"170";
        self.weightLabel.text = ![[result objectForKey:@"user_weight"]isEqualToString:@""]?[result objectForKey:@"user_weight"]:@"50";
        self.addressText.text = ![[result objectForKey:@"user_address"]isEqualToString:@""]?[result objectForKey:@"user_address"]:@"南昌";
        self.signText.text = ![[result objectForKey:@"user_sign"] isEqualToString:@""]?[result objectForKey:@"user_sign"]:@"输入个性签名~";
        [FuncPublic HideHud:hud animating:YES];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"--=-%@",error);
        [WToast showWithText:HTTP_FAIL];
        [FuncPublic HideHud:hud animating:YES];
    }];
}
-(void)addTap{
    UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc]init];
    [self.headerView addGestureRecognizer:headerTap];
    [[headerTap rac_gestureSignal] subscribeNext:^(id x) {
        [self callActionSheetFunc];//选择图片。
    }];
    
    UITapGestureRecognizer *nickNameTap = [[UITapGestureRecognizer alloc]init];
    [self.nickNameView addGestureRecognizer:nickNameTap];
    [[nickNameTap rac_gestureSignal] subscribeNext:^(id x) {
        [self ShowOk:@"昵称" Text:self.nickNameText key:@"user_name"];
    }];
    
    UITapGestureRecognizer *tepTap = [[UITapGestureRecognizer alloc]init];
    [self.telPhoneView addGestureRecognizer:tepTap];
    [[tepTap rac_gestureSignal] subscribeNext:^(id x) {
        [self ShowOk:@"电话号码" Text:self.telPhoneText key:@"user_phone"];
    }];
    
    UITapGestureRecognizer *emailTap = [[UITapGestureRecognizer alloc]init];
    [self.emailView addGestureRecognizer:emailTap];
    [[emailTap rac_gestureSignal] subscribeNext:^(id x) {
        [self ShowOk:@"邮箱" Text:self.emailText key:@"user_email"];
    }];
    
    [[self.boyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.boyBtn.selected = !self.boyBtn.selected;
        self.girlBtn.selected = !self.boyBtn.selected;
        [self sendSex];
    }];
    [[self.girlBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.girlBtn.selected = !self.girlBtn.selected;
        self.boyBtn.selected = !self.girlBtn.selected;
        [self sendSex];
    }];
    
    
    UITapGestureRecognizer *heightTap = [[UITapGestureRecognizer alloc]init];
    [self.heightView addGestureRecognizer:heightTap];
    [[heightTap rac_gestureSignal] subscribeNext:^(id x) {
        [self ShowOk:@"身高(cm)" Text:self.heightText key:@"user_height"];
    }];
    
    UITapGestureRecognizer *weightTap = [[UITapGestureRecognizer alloc]init];
    [self.weightView addGestureRecognizer:weightTap];
    [[weightTap rac_gestureSignal] subscribeNext:^(id x) {
        [self ShowOk:@"体重(kg)" Text:self.weightLabel key:@"user_weight"];
    }];
    
    UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc]init];
    [self.addressView addGestureRecognizer:addressTap];
    [[addressTap rac_gestureSignal] subscribeNext:^(id x) {
        [self ShowOk:@"地址" Text:self.addressText key:@"user_address"];
    }];
    
    UITapGestureRecognizer *signTap = [[UITapGestureRecognizer alloc]init];
    [self.signView addGestureRecognizer:signTap];
    [[signTap rac_gestureSignal] subscribeNext:^(id x) {
        [self ShowOk:@"签名" Text:self.signText key:@"user_sign"];
    }];
}
-(void)sendSex{
    MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:LOADING];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"user" forKey:FLAG];
    [params setValue:@"3" forKey:SERVER_INDEX];
    [params setValue:self.userID forKey:@"user_id"];
    [params setValue:@"user_sex" forKey:@"update_type"];
    if(self.boyBtn.selected == YES){
        [params setValue:@"男" forKey:@"update_values"];
    }else{
        [params setValue:@"女" forKey:@"update_values"];
    }
    [[FuncPublic getAFNetManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData *data = (NSData *)responseObject;
        NSString *state = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if([state isEqualToString:@"1"]){
            [FuncPublic HideHud:hud animating:YES];
        }else{
            [FuncPublic HideHud:hud animating:YES];
            [WToast showWithText:CHANGE_FAIL];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FuncPublic HideHud:hud animating:YES];
        [WToast showWithText:HTTP_FAIL];
    }];
    
}
#pragma mark
-(void)ShowOk:(NSString *)title Text:(UILabel *)label key:(NSString *)key{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = alert.textFields[0];
        if(label == self.nickNameText){//如果是昵称
            if(textField.text.length > 6 || textField.text.length<1){
                [WToast showWithText:@"昵称为1~6位数哦~"];
                return;
            }
        }
        if(label == self.telPhoneText){//如果是电话
            if(![FuncPublic isMobileNumber:textField.text]){
                [WToast showWithText:@"请输入正确手机号格式~"];
                return;
            }
        }
        if(label == self.emailText){//如果是邮箱
            if(![FuncPublic isValidateEmail:textField.text]){
                [WToast showWithText:@"请输入正确的邮箱地址~"];
                return;
            }
        }
        MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:LOADING];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:@"user" forKey:FLAG];
        [params setValue:@"3" forKey:SERVER_INDEX];
        [params setValue:self.userID forKey:@"user_id"];
        [params setValue:key forKey:@"update_type"];
        [params setValue:textField.text forKey:@"update_values"];
        [[FuncPublic getAFNetManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSData *data = (NSData *)responseObject;
            NSString *state = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            if(label == self.nickNameText){//如果是昵称
                [FuncPublic RemoveDefaultbyKey:USER_NAME];
                [FuncPublic SaveDefaultInfo:textField.text Key:USER_NAME];
            }
            if(label == self.telPhoneText){//如果是昵称
                [FuncPublic RemoveDefaultbyKey:USER_TEL];
                [FuncPublic SaveDefaultInfo:textField.text Key:USER_TEL];
            }
            if ([state isEqualToString:@"1"]) {
                label.text =textField.text;
                [FuncPublic HideHud:hud animating:YES];
            } else {
                [FuncPublic HideHud:hud animating:YES];
                [WToast showWithText:CHANGE_FAIL];
            }
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            [FuncPublic HideHud:hud animating:YES];
            [WToast showWithText:HTTP_FAIL];
        }];
        
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.backgroundColor = [UIColor whiteColor];
        textField.placeholder = @"请输入";
        if(label == self.heightText || label == self.weightLabel || label == self.telPhoneText){
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark add a image
-(void)callActionSheetFunc{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.alertController = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }];
        UIAlertAction *photosAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }];
        
        [self.alertController addAction:cancelAction];
        [self.alertController addAction:cameraAction];
        [self.alertController addAction:photosAction];
    }
    [self presentViewController:self.alertController animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //头像选择成功就上传。
    NSData *imageData = UIImageJPEGRepresentation(image, 0.00001);
    MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:LOADING];
    [[FuncPublic getAFNetManager] POST:UPLOAD_IMAGE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *name = [FuncPublic randString:12];
        [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"img%@",name] fileName:[NSString stringWithFormat:@"img%@.jpg",name] mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        //找到返回的图片URL
        NSData *data = (NSData *)responseObject;
        NSString *imageUrl = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *showImageDic = [NSJSONSerialization JSONObjectWithData:[imageUrl dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];//图片
        NSMutableArray *dicArray = [showImageDic objectForKey:@"datas"];
        NSString *url = [dicArray[0] objectForKey:@"imagePath"];
        //重新访问网络将图片URL上传到用户表
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:@"user" forKey:FLAG];
        [params setValue:@"3" forKey:SERVER_INDEX];
        [params setValue:self.userID forKey:@"user_id"];
        [params setValue:@"user_header" forKey:@"update_type"];
        [params setValue:url forKey:@"update_values"];
        AFHTTPRequestOperationManager *manager = [FuncPublic getAFNetManager];
        [manager POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSData *result = responseObject;
            NSString *state = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
            if([state isEqualToString:@"1"]){
                [FuncPublic HideHud:hud animating:YES];
                [FuncPublic RemoveDefaultbyKey:USER_HEADER];
                [FuncPublic SaveDefaultInfo:imageData Key:USER_HEADER];
                self.headerImageView.image = image;
            }else{
                [FuncPublic HideHud:hud animating:YES];
                [WToast showWithText:HTTP_FAIL];
            }
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"%@-=-",error);
            [FuncPublic HideHud:hud animating:YES];
            [WToast showWithText:HTTP_FAIL];
        }];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FuncPublic HideHud:hud animating:YES];
        [WToast showWithText:HTTP_FAIL];
    }];
    
    //坚持者联盟      设置坚持啥   坚持的事情考核方式  每天考核  考核结束分赃。
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
