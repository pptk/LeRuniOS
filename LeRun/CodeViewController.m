//
//  CodeViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/8/12.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "CodeViewController.h"
#import "MainTableViewCell.h"
#import "CodeModel.h"
#import "MJRefresh.h"
#import "GBAvatarBrowser.h"
#import "UIImageView+WebCache.h"
#import "PayViewController.h"
#import "CommentViewController.h"
#import "HistoryDetailViewController.h"
#import "SuccessCodeViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface CodeViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation CodeViewController
{
    NSMutableArray *leRunArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self CreateUI];
//    [FuncPublic hideTabBar:self];
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
//    [FuncPublic hideTabBar:self];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.view.frame = CGRectMake(0, 64, DEVW, DEVH-64);
    return self;
}
-(void)CreateUI{
    self.navigationItem.title = @"二维码";
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
        [WToast showWithText:NO_LOGIN];
        return;
    }
    NSMutableArray *tempArray = [NSMutableArray array];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"lerun" forKey:FLAG];
    [params setObject:@"8" forKey:SERVER_INDEX];
    [params setObject:[FuncPublic GetDefaultInfo:USER_ID] forKey:@"user_id"];
    [params setObject:self.leRunID forKey:@"lerun_id"];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSString *state = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]];
        if([state isEqualToString:@"1"]){
            NSMutableArray *resultArray = [responseObject objectForKey:@"datas"];
            for(int i = 0;i<resultArray.count;i++){
                CodeModel *model = [CodeModel new];
                model.imagePath = [NSString stringWithFormat:@"%@/%@",BASE_URL,[resultArray[i] objectForKey:@"imagePath"]];//图片
                model.userName = [resultArray[i] objectForKey:@"personal_name"];//参与者姓名
                model.signState = [NSString stringWithFormat:@"%@",[resultArray[i] objectForKey:@"sign_state"]];//签到状态
                model.price = [NSString stringWithFormat:@"%@",[resultArray[i] objectForKey:@"payment"]];//付款金额
                model.chargeState = [NSString stringWithFormat:@"%@",[resultArray[i] objectForKey:@"charge_state"]];//付款状态
                model.leRunTitle = [resultArray[i] objectForKey:@"lerun_title"];//标题
                model.evaluateState = [NSString stringWithFormat:@"%@",[resultArray[i] objectForKey:@"evaluate_state"]];//评价状态
                model.telPhoneStr = [NSString stringWithFormat:@"%@",[resultArray[i] objectForKey:@"user_telphone"]];//参与者电话
                model.checkState = [NSString stringWithFormat:@"%@",[resultArray[i] objectForKey:@"check_state"]];//审核状态
                model.leRunID = [NSString stringWithFormat:@"%@",[resultArray[i] objectForKey:@"lerun_id"]];//乐跑ID
                model.Orderid = [NSString stringWithFormat:@"%@",[resultArray[i] objectForKey:@"order_id"]];
                [tempArray addObject:model];
            }
            leRunArray = tempArray;
            [self.tableViews reloadData];
        }else{
            [WToast showWithText:HTTP_FAIL];
        }
        [self.tableViews headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [WToast showWithText:HTTP_FAIL];
    }];
}
#pragma mark delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return leRunArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CodeModel *model = leRunArray[indexPath.row];
    {//二维码
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.imagePath] placeholderImage:[UIImage imageNamed:@"home.jpg"]];
        imageView.clipsToBounds = YES;
        imageView.tag = indexPath.row + 10086;
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:imageView];
    }
    {//参与者姓名
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 30, 100, 16)];
        label.text = model.userName;
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
    }
    {//参与活动标题
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 50, DEVW-120, 30)];
        label.text = model.leRunTitle;
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
    }
    {//价格
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 90, DEVW-120, 16)];
        label.text = [NSString stringWithFormat:@"￥%@",model.price];
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
    }
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(DEVW-60, 20, 40, 16)];
        [cell.contentView addSubview:label];
        label.tag = indexPath.row + 1010;
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:12];
        if([model.checkState isEqualToString:@"1"]){//审核通过
            if([model.chargeState isEqualToString:@"0"]){//未付款
                label.text = @"未付款";
            }else if([model.chargeState isEqualToString:@"1"]){//已付款
                if([model.signState isEqualToString:@"1"]){//已经签到
                    if([model.evaluateState isEqualToString:@"0"]){//未评价
                        label.text = @"去评价";
                    }else if([model.evaluateState isEqualToString:@"1"]){//已经评价
                        label.text = @"已评价";
                        [label setTextColor:[UIColor grayColor]];
                    }
                }else if([model.signState isEqualToString:@"0"]){//未签到
                    label.text = @"未签到";
                }
            }
        }else if([model.checkState isEqualToString:@"0"]){//未审核
            label.text = @"审核中";
        }else if([model.checkState isEqualToString:@"2"]){//审核未通过
            label.text = @"审核未通过";
        }
    }
    [FuncPublic InstanceSimpleView:CGRectMake(0, 119.5, DEVW, 0.5) backgroundColor:RGB(205, 205, 205) addToView:cell.contentView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CodeModel *model = leRunArray[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imageView = [cell viewWithTag:indexPath.row + 10086];
    UILabel *label = [cell viewWithTag:indexPath.row + 1010];
    if([model.checkState isEqualToString:@"1"]){//审核通过
        if([model.chargeState isEqualToString:@"0"]){//未付款
            PayViewController *payVC = [PayViewController new];
            payVC.signUpNameStr = model.userName;
            payVC.signUpLeRunTitleStr = model.leRunTitle;
            payVC.signUpPrice = model.price;
            payVC.signUpUserTel = model.telPhoneStr;
            payVC.signUpLeRunId = model.leRunID;
            payVC.lerunOrder = model.Orderid;
            payVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:payVC animated:YES];
        }else if([model.chargeState isEqualToString:@"1"]){//已付款
            if([model.signState isEqualToString:@"1"]){//已经签到
                if([model.evaluateState isEqualToString:@"0"]){//未评价
                    CommentViewController *commentVC = [CommentViewController new];
                    commentVC.leRunID = self.leRunID;
                    commentVC.telPhone = model.telPhoneStr;
                    commentVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:commentVC animated:YES];
                }else if([model.evaluateState isEqualToString:@"1"]){//已经评价
                    HistoryDetailViewController *hdVC = [HistoryDetailViewController new];
                    hdVC.leRunID = self.leRunID;
                    hdVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:hdVC animated:YES];
                }
            }else if([model.signState isEqualToString:@"0"]){//未签到
                 [self goToSuccessCodeVC:[NSString stringWithFormat:@"%@%@",model.leRunTitle,label.text] image:imageView.image];
            }
        }
    }else if([model.checkState isEqualToString:@"0"]){//未审核
        [self goToSuccessCodeVC:[NSString stringWithFormat:@"%@%@",model.leRunTitle,label.text] image:imageView.image];
    }else if([model.checkState isEqualToString:@"2"]){//审核未通过
        [self goToSuccessCodeVC:[NSString stringWithFormat:@"%@%@",model.leRunTitle,label.text] image:imageView.image];
    }
}
-(void)goToSuccessCodeVC:(NSString *)str image:(UIImage *)image{
    SuccessCodeViewController *scVC = [SuccessCodeViewController new];
    scVC.tipText = str;
    scVC.codeImage = image;
    scVC.fromStr = @"code";
    [self.navigationController pushViewController:scVC animated:YES];
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