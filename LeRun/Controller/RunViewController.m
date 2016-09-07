//
//  RunViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/5.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "RunViewController.h"
#import "MainTableViewCell.h"
#import "PictureScrollView.h"
#import "FuncPublic.h"
#import "LeRunModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "HeaderView.h"
#import "RunLeWebViewController.h"
#import "DetailViewController.h"
#import "TrackViewController.h"
#import "ThemeViewController.h"
#import "ActivityViewController.h"
#import "LoginViewController.h"
#import "UIImage+Tint.h"
#import "UIControl+PengXiongHui.h"
#import "ProviderSelectedViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface RunViewController ()<UITableViewDataSource,UITableViewDelegate,DelegateClick,ProviderDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation RunViewController
{
    NSMutableArray *mainArray;
    UIView *grayView,*alertView;
    CATextLayer *textLayer;//网络无法连接
    UILabel *addres;//地址
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mainArray = [NSMutableArray array];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    //    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainTableView addHeaderWithCallback:^{
        if([FuncPublic GetDefaultInfo:USER_PROVINCE]){
            [self getData:[FuncPublic GetDefaultInfo:USER_PROVINCE]];
        }else{
            [self getData:@"江西"];
        }
    }];
    [self.mainTableView headerBeginRefreshing];
    
    [self createNav];
}
-(void)viewDidAppear:(BOOL)animated{
    [FuncPublic showTabBar:self];
}
-(void)createNav{
    [self.navigationController.navigationBar    setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];//设置文字白色
    self.navigationItem.title = @"乐跑";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];//设置返回为白色
    //设置左侧icon
//    CGRect backframe = CGRectMake(0,0,40,30);
//    UIButton* backButton= [[UIButton alloc] initWithFrame:backframe];
//    [backButton setTitle:@"南昌" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [[backButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
//        [self.mainTableView headerBeginRefreshing];
//    }];
    
    UIControl   *control = [[UIControl alloc]   initWithFrame:CGRectMake(0, 0,  70, 20)];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5,  15, 15)];
    img.image  = [[UIImage imageNamed:@"address.png"] imageWithTintColor:[UIColor whiteColor]];
    addres = [[UILabel alloc]initWithFrame:CGRectMake(17, 3, 50, 20)];
    if([FuncPublic GetDefaultInfo:USER_PROVINCE]){
        addres.text = [FuncPublic GetDefaultInfo:USER_PROVINCE];
    }else{
        addres.text = @"江西";
    }
    addres.textAlignment = NSTextAlignmentLeft;
    addres.font = [UIFont systemFontOfSize:14];
    addres.textColor = [UIColor whiteColor];
    [control addTarget:self action:@selector(clickAddres) forControlEvents:UIControlEventTouchUpInside];
    [control addSubview:img];
    [control addSubview:addres];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:control];
    self.navigationItem.leftBarButtonItem = leftBtn;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:control];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}
-(void)clickAddres{//选择省份。
    ProviderSelectedViewController *psVC = [ProviderSelectedViewController new];
    psVC.delegate = self;
    psVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:psVC animated:YES];
}
-(void)selectedProvider:(NSString *)provider{
    addres.text = provider;
    if([FuncPublic isNilOrEmpty:[FuncPublic GetDefaultInfo:USER_PROVINCE]]){
        [FuncPublic SaveDefaultInfo:provider Key:USER_PROVINCE];
    }else{
        [FuncPublic RemoveDefaultbyKey:USER_PROVINCE];
        [FuncPublic SaveDefaultInfo:provider Key:USER_PROVINCE];
    }
    //刷新主页数据。
    [self getData:provider];
}
-(void)getData:(NSString *)province{
    NSMutableArray *tempArray = [NSMutableArray array];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"0" forKey:SERVER_INDEX];
    [params setObject:@"lerun" forKey:FLAG];
    [params setObject:province forKey:@"lerun_province"];
    AFHTTPRequestOperationManager *manager = [FuncPublic getAFNetJSONManager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5;
    [manager POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *array= [responseObject objectForKey:@"result"];
        if(array.count >0){
            for(int i = 0;i<array.count;i++){
                LeRunModel *model = [LeRunModel new];
                model.leRunID = [array[i] objectForKey:@"lerun_id"];
                model.leRunAddress = [array[i] objectForKey:@"lerun_address"];
                model.leRunState = [NSString stringWithFormat:@"%@",[array[i] objectForKey:@"lerun_state"]];
                model.leRunTitle = [array[i] objectForKey:@"lerun_title"];
                model.leRunTime = [array[i] objectForKey:@"lerun_time"];
                model.posterImage = [NSString stringWithFormat:@"%@/%@",BASE_URL,[array[i] objectForKey:@"lerun_poster"]];
                model.leRunBrowse =[NSString stringWithFormat:@"%@",[array[i] objectForKey:@"lerun_browsenum"]];
                model.loveCount = [NSString stringWithFormat:@"%@",[array[i] objectForKey:@"lerun_likenum"]];
                [tempArray addObject:model];
            }
            mainArray = tempArray;
            [textLayer removeFromSuperlayer];
            [self addHeader];
        }else{
            [WToast showWithText:@"后台服务器异常"];
        }
        [self.mainTableView reloadData];
        [self.mainTableView headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self.mainTableView headerEndRefreshing];
        if(!textLayer){
            textLayer = [CATextLayer layer];
        }
        textLayer.frame = CGRectMake(0, DEVH/3, DEVW, DEVH);
        [self.mainTableView.layer addSublayer:textLayer];
        textLayer.foregroundColor = [UIColor blackColor].CGColor;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        textLayer.wrapped = YES;
        UIFont *font = [UIFont systemFontOfSize:20];
        CFStringRef fontName = (__bridge CFStringRef)font.fontName;
        CGFontRef fontRef = CGFontCreateWithFontName(fontName);
        textLayer.font = fontRef;
        textLayer.fontSize = font.pointSize;
        textLayer.string = @"网络无法连接...";
        textLayer.foregroundColor = RGB(188, 188, 188).CGColor;
        [WToast showWithText:HTTP_FAIL];
    }];
}
#pragma mark 添加头部
-(void)addHeader{
    HeaderView *headerV = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, DEVW, 554)];
    headerV.modelArray = [[NSMutableArray alloc]initWithObjects:mainArray[0],mainArray[1], nil];
    headerV.delegate = self;
    self.mainTableView.tableHeaderView = headerV;
}
#pragma mark header delegate
-(void)trackClick{//足迹
    TrackViewController *tVC = [[TrackViewController alloc]init];
    tVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tVC animated:YES];
}
-(void)activityClick{//活动页面
    ActivityViewController *aVC = [[ActivityViewController alloc]init];
    aVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aVC animated:YES];
}
-(void)themeClick{//主题页面
    ThemeViewController *tVC = [[ThemeViewController alloc]init];
    tVC.view.clipsToBounds = YES;
    tVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tVC animated:YES];
}

-(void)signClick{//签到二维码
    if([[FuncPublic GetDefaultInfo:IS_LOGIN] isEqualToString:@"true"] && ![FuncPublic isEmpty:[FuncPublic GetDefaultInfo:USER_TEL]]  && ![FuncPublic isEmpty:[FuncPublic GetDefaultInfo:USER_ID]]){//已经登录
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"10" forKey:SERVER_INDEX];
        [params setObject:@"lerun" forKey:FLAG];
        [params setObject:[FuncPublic GetDefaultInfo:USER_ID] forKey:@"user_id"];
        [params setObject:[FuncPublic GetDefaultInfo:USER_TEL] forKey:@"user_telphone"];
        MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
        [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            [FuncPublic HideHud:hud animating:YES];
            NSDictionary *result = (NSDictionary *)responseObject;
            NSString *state = [NSString stringWithFormat:@"%@",[result objectForKey:@"state"]];
            if([state isEqualToString:@"1"]){//成功。
                NSString *codeURL = [NSString stringWithFormat:@"%@/%@",BASE_URL,[result objectForKey:@"datas"]];
                NSString *titleString = @"卡乐泡泡跑签到二维码";
                UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
                grayView = [[UIView alloc]initWithFrame:window.bounds];
                grayView.backgroundColor = RGBA(205, 205, 205, 0.4);
                [window addSubview:grayView];
                grayView.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
                [[tap rac_gestureSignal] subscribeNext:^(id x) {
                    [grayView removeFromSuperview];
                }];
                tap.delegate = self;//监听到触摸方法,如果在alertView中，就不响应，如果不在alertView中就remove
                [grayView addGestureRecognizer:tap];
                alertView = [[UIView alloc]initWithFrame:CGRectMake(30, (DEVH-(DEVW-60))/2, DEVW-60, DEVW-60)];
                alertView.backgroundColor = [UIColor whiteColor];
                alertView.layer.cornerRadius = 20;
                alertView.layer.masksToBounds = YES;
                [grayView addSubview:alertView];
                [FuncPublic InstanceSimpleView:CGRectMake(10, 39.5, DEVW-80, 0.5) backgroundColor:RGB(205, 205, 205) addToView:alertView];
                UIImageView *codeImageView = [FuncPublic InstanceSimpleImageView:nil Rect:CGRectMake(10, 50, DEVW-80, DEVW-60-80-20) userInteractionEnabled:NO alpha:1 addtoView:alertView andTag:0];
                codeImageView.contentMode = UIViewContentModeScaleAspectFit;
                codeImageView.clipsToBounds = YES;
                [codeImageView sd_setImageWithURL:[NSURL URLWithString:codeURL] placeholderImage:[UIImage imageNamed:@"home.jpg"]];
                [FuncPublic InstanceSimpleView:CGRectMake(10, DEVW-60-40, DEVW-80, 0.5) backgroundColor:RGB(205, 205, 205) addToView:alertView];
                [FuncPublic InstanceSimpleLabel:titleString Rect:CGRectMake(20,0,DEVW-60-40,40) addToView:alertView Font:[UIFont systemFontOfSize:14] andTextColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] Aligment:1];
                UIButton *okBtn = [FuncPublic InstanceSimpleBtn:@"确定" Rect:CGRectMake(20, DEVW-100, DEVW-100, 40) addToView:alertView titleFont:16 titleColor:RGB(21,153,224) background:[UIColor clearColor] target:nil];
                [[okBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                    [grayView removeFromSuperview];
                }];
                
            }else if([state isEqualToString:@"0"]){
                [WToast showWithText:[result objectForKey:@"datas"]];
            }else{
                [WToast showWithText:HTTP_FAIL];
            }
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"--%@",error);
            [FuncPublic HideHud:hud animating:YES];
            [FuncPublic showToast:@"网络异常~"];
        }];
    }else{
        LoginViewController *lVC = [LoginViewController new];
        [self.navigationController pushViewController:lVC animated:YES];
    }
}

-(void)vedioClick:(NSString *)url{
    RunLeWebViewController *webVC = [[RunLeWebViewController alloc]init];
    webVC.urlStr = url;
    webVC.title = @"视频";
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}
-(void)leRunClick1{//活动详情页
    LeRunModel *model = mainArray[0];
    [self gotoDetail:model.leRunID];
}
-(void)leRunClick2{
    LeRunModel *model = mainArray[1];
    [self gotoDetail:model.leRunID];
}
-(void)pictureScrollViewClick:(NSString *)url{
    RunLeWebViewController *rwVC = [RunLeWebViewController new];
    rwVC.urlStr = url;
    rwVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rwVC animated:YES];
}

#pragma mark tap delegate
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint tapPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
    if(CGRectContainsPoint(alertView.frame, tapPoint)){
        return NO;
    }
    return YES;
}
#pragma mark tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mainArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 138;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"maincells";
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ActivityCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LeRunModel *model = mainArray[indexPath.row];
    cell.titleLabel.text = model.leRunTitle;
    cell.timeLabel.text = model.leRunTime;
    cell.addressLabel.text = model.leRunAddress;
    if([model.leRunState isEqualToString:@"0"]){
        cell.stateLabel.text = @"报名中";
    }else if([model.leRunState isEqualToString:@"1"]){
        cell.stateLabel.text = @"报名已结束";
    }else if([model.leRunState isEqualToString:@"2"]){
        cell.stateLabel.text = @"活动进行中";
    }else if([model.leRunState isEqualToString:@"3"]){
        cell.stateLabel.text = @"活动已结束";
    }
    [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:model.posterImage] placeholderImage:[UIImage imageNamed:@"home.jpg"]];
    cell.headerImage.clipsToBounds = YES;
    cell.seeLabel.text = [NSString stringWithFormat:@"浏览%@次",model.leRunBrowse];
    cell.loveLabel.text = model.loveCount;
    [cell.loveBtn removeAllTargets];
    [[cell.loveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self loveAction:cell model:model];
    }];
    
    [FuncPublic InstanceSimpleView:CGRectMake(0, 137.5, DEVW, 0.5) backgroundColor:RGBCOLOR(205, 205, 205) addToView:cell.contentView];
    
    return cell;
}
-(void)loveAction:(MainTableViewCell *)cell model:(LeRunModel *)model{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"11" forKey:SERVER_INDEX];
    [params setObject:@"lerun" forKey:FLAG];
    [params setObject:model.leRunID forKey:@"lerun_id"];
    MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [FuncPublic HideHud:hud animating:YES];
        NSString *state = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]];
        if([state isEqualToString:@"1"]){
            cell.loveBtn.selected = !cell.loveBtn.selected;
            if(cell.loveBtn.selected){
                cell.loveLabel.text = [NSString stringWithFormat:@"%d",[cell.loveLabel.text intValue]+1];
            }else{
                cell.loveLabel.text = [NSString stringWithFormat:@"%d",[cell.loveLabel.text intValue]-1];
            }
            [WToast showWithText:@"点赞成功"];
        }else{
            [WToast showWithText:@"操作失败"];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FuncPublic HideHud:hud animating:YES];
        [WToast showWithText:HTTP_FAIL];
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LeRunModel *model = mainArray[indexPath.row];
    [self gotoDetail:model.leRunID];
}
-(void)gotoDetail:(NSString *)lerunID{
    DetailViewController *dVC = [[DetailViewController alloc]init];
    dVC.leRunID = lerunID;
    dVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dVC animated:YES];
}
-(void)didReceiveMemoryWarning {
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
