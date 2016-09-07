//
//  SignUpViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/27.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "SignUpViewController.h"
#import "PriceTableViewCell.h"
#import "UIButton+WebCache.h"
#import "PayViewController.h"
#import "SuccessCodeViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface SignUpViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UIAlertController *alertController;
@end

@implementation SignUpViewController

{
    UIPickerView *certificatesTypePickerView;
    UIPickerView *identityPickerView;
    NSArray *certificatesTypeArray;
    NSArray *identityTypeArray;
    UIView *grayView;
    NSInteger selectedFlag;
    
    NSString *price;
    UIImage *codeImage;//二维码图片
    UIImage *workImage;//身份信息验证照片。
    BOOL mustImage;//是否需要身份认证照片。
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title =  @"报名";
    [self createUI];
    selectedFlag = -1;
    grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVW, DEVH-160)];
    grayView.backgroundColor = [UIColor grayColor];
    grayView.alpha = 0.5;
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    [grayView addGestureRecognizer:tap];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        [certificatesTypePickerView removeFromSuperview];
        [identityPickerView removeFromSuperview];
        [grayView removeFromSuperview];
    }];
    NSLog(@"%@",self.chargeArray);
}
-(void)createUI{
    
    self.signUpName.delegate = self;
    self.signUpCertificatesID.delegate = self;
    self.signUpFrom.delegate = self;
    
    self.leRunTitle.text = [self.leRunDic objectForKey:@"title"];
    self.leRunTime.text = [self.leRunDic objectForKey:@"time"];
    self.leRunAddress.text = [self.leRunDic objectForKey:@"address"];
    //身份证
    self.signUpCertificatesID.keyboardType = UIKeyboardTypeAlphabet;
    //性别
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil];
    [self.signUpSex setTitleTextAttributes:dict forState:UIControlStateNormal];
    [self.signUpSex setTintColor:RGB(0x2a, 0x2c, 0x27)];
    //证件类型
    certificatesTypeArray = @[@" 请选择",@" 身份证",@" 护照",@" 台胞证",@" 港澳居民身份证"];
    UITapGestureRecognizer *tapType = [UITapGestureRecognizer new];
    [self.signUpCertificatesType addGestureRecognizer:tapType];
    [[tapType rac_gestureSignal] subscribeNext:^(id x) {
        [self.view endEditing:YES];
        certificatesTypePickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, DEVH-160, DEVW, 160)];
        certificatesTypePickerView.backgroundColor = [UIColor whiteColor];
        certificatesTypePickerView.delegate = self;
        certificatesTypePickerView.dataSource = self;
        [self.view addSubview:grayView];
        [self.view addSubview:certificatesTypePickerView];
    }];
    self.signUpCertificatesType.layer.borderColor = RGB(205, 205, 205).CGColor;
    self.signUpCertificatesType.layer.borderWidth = 0.5;
    self.signUpCertificatesType.layer.cornerRadius = 5;
    self.signUpCertificatesType.layer.masksToBounds = YES;
    //衣服尺码
    [self.signUpClothesSize setTitleTextAttributes:dict forState:UIControlStateNormal];
    [self.signUpClothesSize setTintColor:RGB(0x2a, 0x2c, 0x27)];
    //身份
    identityTypeArray = @[@" 请选择",@" 承办方",@" 非承办方"];
    UITapGestureRecognizer *tapWork = [UITapGestureRecognizer new];
    [self.signUpWork addGestureRecognizer:tapWork];
    [[tapWork rac_gestureSignal] subscribeNext:^(id x) {
        [self.view endEditing:YES];
        identityPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, DEVH-160, DEVW, 160)];
        identityPickerView.backgroundColor = [UIColor whiteColor];
        identityPickerView.delegate = self;
        identityPickerView.dataSource = self;
        [self.view addSubview:grayView];
        [self.view addSubview:identityPickerView];
    }];
    self.signUpWork.layer.borderColor = RGB(205, 205, 205).CGColor;
    self.signUpWork.layer.borderWidth = 0.5;
    self.signUpWork.layer.cornerRadius = 5;
    self.signUpWork.layer.masksToBounds = YES;
    //联系电话
    self.signUpTelphone.keyboardType = UIKeyboardTypeDecimalPad;
    self.signUpTelphone.delegate = self;
    //身份认证
    [[self.signUpSign rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self callActionSheetFunc];
    }];
    //价格。wait
    self.priceList.scrollEnabled = NO;
    self.priceList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.priceList.delegate = self;
    self.priceList.dataSource = self;
    
    //保险按钮
    [[self.signUpSafe rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.signUpSafe.selected = !self.signUpSafe.selected;
    }];
    
    //报名按钮
    self.signBtn.layer.cornerRadius = 5;
    self.signBtn.layer.masksToBounds = YES;
    [[self.signBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if([FuncPublic isNilOrEmpty:[FuncPublic GetDefaultInfo:USER_ID]]){
            [WToast showWithText:NO_LOGIN];
            return;
        }
        if([FuncPublic isNilOrEmpty:self.signUpName.text]){//如果姓名为空。
            [FuncPublic ShowAlert:@"请输入真实姓名" ViewController:self action:nil];
            return;
        }
        if([self.signUpCertificatesType.text isEqualToString:@" 请选择"]){
            [FuncPublic ShowAlert:@"请选择证件类型" ViewController:self action:nil];
            return;
        }
        if([FuncPublic isNilOrEmpty:self.signUpCertificatesID.text]){
            [FuncPublic ShowAlert:@"请填写证件号码" ViewController:self action:nil];
            return;
        }
//        if([self.signUpWork.text isEqualToString:@" 请选择"]){
//            [FuncPublic ShowAlert:@"请选择身份信息" ViewController:self action:nil];
//            return;
//        }
        if([FuncPublic isNilOrEmpty:self.signUpTelphone.text]){
            [FuncPublic ShowAlert:@"请填写手机号码" ViewController:self action:nil];
            return;
        }
        if(![FuncPublic isMobileNumber:self.signUpTelphone.text]){
            [FuncPublic ShowAlert:@"请填写正确的手机号" ViewController:self action:nil];
            return;
        }
        if(self.signUpSafe.selected == NO){
            [FuncPublic ShowAlert:@"请点击同意购买保险" ViewController:self action:nil];
            return;
        }
        if(selectedFlag < 0){
            [FuncPublic ShowAlert:@"请选择价格" ViewController:self action:nil];
            return;
        }
        NSLog(@"%@",self.leRunDic);
        switch ([[self.leRunDic objectForKey:@"charge_mode"] intValue]) {
            case 1://全免费
            {
                    NSMutableDictionary *params = [self getParams];
                    [self signNetWork:params];
            }
                break;
            case 2://部分免费
            {
                NSMutableDictionary *params = [self getParams];
                if([[NSString stringWithFormat:@"%@",[params objectForKey:@"payment"]] isEqualToString:@"0"]){
                    if([self.signUpWork.text isEqualToString:@" 承办方"]){//如果选择的身份是承办方
                        if(![FuncPublic isEmpty:workImage]){//照片不为空
                            mustImage = YES;
                            [params setObject:@"1" forKey:@"signin_type"];
                            [self signNetWork:params];
                        }else{
                            [WToast showWithText:@"请上传身份认真照片(承办方需要上传身份认证照片进行审核)"];
                        }
                    }else{
                        [WToast showWithText:@"免费仅为承办方提供哦~"];
                    }
                }else{
                    [self signNetWork:[self getParams]];//直接报名
                }
                
            }
                break;
            case 3://全收费
            {
                NSMutableDictionary *params = [self getParams];
                [self signNetWork:params];
            }
                break;
            default:
                break;
        }
    }];
    
}
#pragma mark 生成二维码，上传证件照，完善报名的最后参数
-(void)signNetWork:(NSMutableDictionary *)params{
    [FuncPublic ShowAlert:[NSString stringWithFormat:@"姓名:%@\n证件号:%@\n电话:%@",self.signUpName.text,self.signUpCertificatesID.text,self.signUpTelphone.text] title:@"请确认输入信息" ViewController:self action:^{
        //生成二维码
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[FuncPublic GetDefaultInfo:USER_ID] forKey:@"user_id"];
        [dic setObject:[self.leRunDic objectForKey:@"lerun_id"] forKey:@"lerun_id"];
        [dic setObject:[params objectForKey:@"user_telphone"] forKey:@"user_telphone"];
        codeImage = [self produceCode:[NSString stringWithFormat:@"%@",dic]];
        NSData *data = UIImageJPEGRepresentation(codeImage, 0.0001);
        MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
        [[FuncPublic getAFNetJSONManager] POST:UPLOAD_IMAGE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSString *name = [FuncPublic randString:12];
            [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"img%@",name] fileName:[NSString stringWithFormat:@"img%@.jpg",name] mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            [FuncPublic HideHud:hud animating:YES];
            NSArray *datas = [responseObject objectForKey:@"datas"];
            NSString *imageUrl = [datas[0] objectForKey:@"imagePath"];
            [params setObject:imageUrl forKey:@"QRcode_Path"];
            if(mustImage){//如果需要上传身份认证图片
                MBProgressHUD *hub = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
                NSData *data = UIImageJPEGRepresentation(workImage, 0.0001);
                [[FuncPublic getAFNetJSONManager] POST:UPLOAD_IMAGE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    NSString *name = [FuncPublic randString:12];
                    [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"img%@",name] fileName:[NSString stringWithFormat:@"img%@.jpg",name] mimeType:@"image/jpeg"];
                } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                    [FuncPublic HideHud:hub animating:YES];
                    NSArray *datas = [responseObject objectForKey:@"datas"];
                    NSString *imageUrl = [datas[0] objectForKey:@"imagePath"];
                    [params setObject:imageUrl forKey:@"certificate_image"];
                    [self post:params];
                } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                    [FuncPublic HideHud:hub animating:YES];
                    [WToast showWithText:HTTP_FAIL];
                }];
            }else{//无照片报名
                [self post:params];
            }
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            [FuncPublic HideHud:hud animating:YES];
            [WToast showWithText:HTTP_FAIL];
        }];
    } cancelAction:^{
        return;
    } showEndAction:nil];
}
#pragma mark 报名操作
-(void)post:(NSMutableDictionary *)params{
    MBProgressHUD *hub = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [FuncPublic HideHud:hub animating:YES];
        NSString *state = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]];
        NSString *datas = [responseObject objectForKey:@"datas"];
        if([state isEqualToString:@"1"]){
            //到支付页面
            if([[self.chargeArray[selectedFlag] objectForKey:@"price"] isEqualToString:@"0"]){//如果选择的是免费,直接生成二维码，并且存储
                if([[params objectForKey:@"signin_type"] isEqualToString:@"1"]){
                    datas = @"身份信息审核通过后即可生效！\n在我的乐跑中查看！";
                }else{
                    datas = [datas stringByAppendingString:@"\n在我的乐跑中查看！"];
                }
                SuccessCodeViewController *scVC = [SuccessCodeViewController new];
                scVC.codeImage = codeImage;
                scVC.tipText = datas;
                scVC.fromStr = @"sign";
                [self.navigationController pushViewController:scVC animated:YES];
            }else{
                PayViewController *payVC = [PayViewController new];
                payVC.signUpNameStr = self.signUpName.text;
                payVC.signUpLeRunTitleStr = [self.chargeArray[selectedFlag] objectForKey:@"equipment"];
                payVC.signUpUserTel = [params objectForKey:@"user_telphone"];
                payVC.signUpPrice = [self.chargeArray[selectedFlag] objectForKey:@"price"];
                payVC.signUpLeRunId = [self.leRunDic objectForKey:@"lerun_id"];
                payVC.codeImage = codeImage;
                payVC.lerunOrder = [params objectForKey:@"order_id"];
                [self.navigationController pushViewController:payVC animated:YES];
            }
        }else{
            [WToast showWithText:datas];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FuncPublic HideHud:hub animating:YES];
        [WToast showWithText:HTTP_FAIL];
        NSLog(@"%@",error);
    }];
}

-(NSMutableDictionary *)getParams{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"lerun" forKey:FLAG];
    [params setObject:@"4" forKey:SERVER_INDEX];
    [params setObject:[FuncPublic GetDefaultInfo:USER_ID] forKey:@"user_id"];
    [params setObject:[self.leRunDic objectForKey:@"lerun_id"] forKey:@"lerun_id"];
    [params setObject:self.signUpTelphone.text forKey:@"user_telphone"];//报名者联系电话
    [params setObject:[self.leRunDic objectForKey:@"title"] forKey:@"lerun_title"];//乐跑title
    [params setObject:self.signUpName.text forKey:@"personal_name"];//报名者姓名
    [params setObject:self.signUpFrom.text forKey:@"company_name"];//公司名字
    [params setObject:self.signUpWork.text forKey:@"identity_type"];//身份类型。
    [params setObject:self.signUpCertificatesType.text forKey:@"identity_type"];//证件类型
    [params setObject:self.signUpCertificatesID.text forKey:@"identity_card"];//证件号
    [params setObject:@"1" forKey:@"insurance_id"];//保险
    [params setObject:[self.signUpClothesSize titleForSegmentAtIndex:self.signUpClothesSize.selectedSegmentIndex] forKey:@"dress_size"];//衣服尺寸
    [params setObject:[self.chargeArray[selectedFlag] objectForKey:@"price"] forKey:@"payment"];//支付金额
    [params setObject:[self.signUpSex titleForSegmentAtIndex:self.signUpSex.selectedSegmentIndex] forKey:@"user_sex"];//衣服尺寸
    [params setObject:[self.leRunDic objectForKey:@"charge_mode"] forKey:@"charge_mode"];
    [params setObject:@"" forKey:@"certificate_image"];
    [params setObject:@"2" forKey:@"signin_type"];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *str = [dateFormatter stringFromDate:[NSDate date]];
    [params setObject:[NSString stringWithFormat:@"%@%@",str,[FuncPublic randString:10]] forKey:@"order_id"];//生成唯一订单号
    return params;
}

//生成二维码
-(UIImage *)produceCode:(NSString *)str{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    CIImage *outPutImage = [filter outputImage];
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];  
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outPutImage withSize:400.0];
    return image;
}
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
#pragma mark text field delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeyDone;
    [textField becomeFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark picker Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView == certificatesTypePickerView){
        return 5;
    }else if(pickerView == identityPickerView){
        return 3;
    }
    return 0;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView == certificatesTypePickerView){
        return certificatesTypeArray[row];
    }else if(pickerView == identityPickerView){
        return identityTypeArray[row];
    }
    return nil;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(row != 0){
        if(pickerView == certificatesTypePickerView){
            self.signUpCertificatesType.text = certificatesTypeArray[row];
            [self.signUpCertificatesType setTextColor:RGB(47, 47, 47)];
        }else if(pickerView == identityPickerView){
            self.signUpWork.text = identityTypeArray[row];
            [self.signUpWork setTextColor:RGB(47, 47, 47)];
        }
    }
}
#pragma mark tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chargeArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"pricecell";
    PriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"PriceTableViewCell" bundle:nil];
        cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row == selectedFlag){
        cell.selectedState.selected = YES;
    }else{
        cell.selectedState.selected = NO;
    }
    cell.contentView.layer.borderWidth = 0.5;
    cell.contentView.layer.borderColor = RGB(205, 205, 205).CGColor;
    if([[self.chargeArray[indexPath.row] objectForKey:@"price"] isEqualToString:@"0"]){
        cell.priceLabel.text = @"免费";
    }else{
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",[self.chargeArray[indexPath.row] objectForKey:@"price"]];
    }
    if([[self.leRunDic objectForKey:@"free_num"] intValue] <= 0 && indexPath.row == 0 && [[self.leRunDic objectForKey:@"charge_mode"] isEqualToString:@"2"]){//如果没有了免费的名额
        cell.detailLabel.text = @"免费名额已满";
    }else{
        cell.detailLabel.text = [self.chargeArray[indexPath.row] objectForKey:@"equipment"];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([[self.leRunDic objectForKey:@"free_num"] isEqualToString:@"0"] && [[self.chargeArray[indexPath.row] objectForKey:@"price"] isEqualToString:@"0"]){
        [WToast showWithText:@"已经没有免费名额了"];
    }else{
        selectedFlag = indexPath.row;
        [self.priceList reloadData];
    }
}

#pragma mark 图片
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
    workImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //头像选择成功就上传。
    [self.signUpSign setImage:workImage forState:UIControlStateNormal];
}
-(void)viewDidAppear:(BOOL)animated{
    
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //    if()
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
