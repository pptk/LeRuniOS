//
//  MyLeRunViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/23.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "MyLeRunViewController.h"
#import "MJRefresh.h"
#import "MainTableViewCell.h"
#import "LeRunModel.h"
#import "UIImageView+WebCache.h"
#import "CodeViewController.h"

#define T DEVH*1/5
#define H DEVH*3/5

@interface MyLeRunViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyLeRunViewController
{
    NSMutableArray *leRunArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [FuncPublic hideTabBar:self];
    self.navigationItem.title = @"我的乐跑";
    [self createUI];
    
}
-(void)createUI{
    leRunArray = [NSMutableArray array];
    self.tableViews.delegate = self;
    self.tableViews.dataSource = self;
    self.tableViews.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableViews];
    @weakify(self);
    [self.tableViews addHeaderWithCallback:^{
        @strongify(self);
        [self getData];
    }];
    [self.tableViews headerBeginRefreshing];
}
-(void)getData{
    if([FuncPublic isNilOrEmpty:[FuncPublic GetDefaultInfo:USER_ID]]){
        [self.tableViews headerEndRefreshing];
        [WToast showWithText:NO_LOGIN];
        return;
    }
    NSMutableArray *tempArray = [NSMutableArray array];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"lerun" forKey:FLAG];
    [params setObject:@"6" forKey:SERVER_INDEX];
    [params setObject:[FuncPublic GetDefaultInfo:USER_ID] forKey:@"user_id"];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSMutableArray *resultArray = [responseObject objectForKey:@"result"];
        for(int i = 0;i<resultArray.count;i++){
            LeRunModel *model = [LeRunModel new];
            model.leRunAddress = [resultArray[i] objectForKey:@"lerun_address"];//地址
            model.posterImage = [NSString stringWithFormat:@"%@/%@",BASE_URL,[resultArray[i] objectForKey:@"lerun_poster"]];//图片
            model.leRunTime = [resultArray[i] objectForKey:@"lerun_time"];//时间
            model.leRunTitle = [resultArray[i] objectForKey:@"lerun_title"];//名字
            model.leRunType = [resultArray[i] objectForKey:@"lerun_type"];//活动类型
            model.leRunID = [NSString stringWithFormat:@"%@",[resultArray[i] objectForKey:@"lerun_id"]];//活动ID
            model.leRunState = [NSString stringWithFormat:@"%@",[resultArray[i] objectForKey:@"lerun_state"]];
            [tempArray addObject:model];
        }
        [self.tableViews headerEndRefreshing];
        leRunArray = tempArray;
        [self.tableViews reloadData];
        if(leRunArray.count == 0){
            CALayer *layer = [CALayer layer];
            layer.frame = CGRectMake(0, T, DEVW, H);
            UIImage *image = [UIImage imageNamed:@"home.jpg"];
            layer.contents = (__bridge id)image.CGImage;
            layer.zPosition = -1;
            [self.view.layer addSublayer:layer];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [WToast showWithText:HTTP_FAIL];
    }];
}
#pragma mark delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return leRunArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 138;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"maincells";
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MyLeRunCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LeRunModel *model = leRunArray[indexPath.row];
    [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:model.posterImage] placeholderImage:[UIImage imageNamed:@"home.jpg"]];
    cell.headerImage.clipsToBounds = YES;
    cell.titleLabel.text = model.leRunTitle;
    cell.timeLabel.text = model.leRunTime;
    cell.addressLabel.text = model.leRunAddress;
    if([model.leRunState isEqualToString:@"0"]){
        cell.stateLabel.text = @"报名中";
    }else if([model.leRunState isEqualToString:@"1"]){
        cell.stateLabel.text = @"报名截止";
    }else if([model.leRunState isEqualToString:@"2"]){
        cell.stateLabel.text = @"活动进行中";
    }else if([model.leRunState isEqualToString:@"3"]){
        cell.stateLabel.text = @"活动结束";
    }
    [FuncPublic InstanceSimpleView:CGRectMake(0, 137.5, DEVW, 0.5) backgroundColor:RGB(205, 205, 205) addToView:cell.contentView];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LeRunModel *model = leRunArray[indexPath.row];
    CodeViewController *codeVC = [CodeViewController new];
    codeVC.leRunID = model.leRunID;
    codeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:codeVC animated:YES];
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
