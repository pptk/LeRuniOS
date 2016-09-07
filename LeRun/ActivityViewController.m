//
//  ActivityViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/14.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "ActivityViewController.h"
#import "MJRefresh.h"
#import "MainTableViewCell.h"
#import "LeRunModel.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"
#import "UIControl+PengXiongHui.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface ActivityViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ActivityViewController
{
    NSMutableArray *mainArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"活动";
//    [FuncPublic hideTabBar:self];
    mainArray = [NSMutableArray array];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    [self.mainTableView addHeaderWithCallback:^{
        [self getData];
    }];
    [self.mainTableView headerBeginRefreshing];
}
-(void)getData{
    NSMutableArray *tempArray = [NSMutableArray array];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"0" forKey:SERVER_INDEX];
    [params setObject:@"lerun" forKey:FLAG];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //        [responseObject objectForKey:@""];
        NSLog(@"%@",responseObject);
        NSArray *array= [responseObject objectForKey:@"result"];
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
        [self.mainTableView reloadData];
        [self.mainTableView headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [self.mainTableView headerEndRefreshing];
    }];

}
#pragma mark delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mainArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 138;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"maincells";
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ActivityCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LeRunModel *model = mainArray[indexPath.row];
    [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:model.posterImage] placeholderImage:[UIImage imageNamed:@"home.jpg"]];
    cell.headerImage.clipsToBounds = YES;
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
    
    cell.seeLabel.text = [NSString stringWithFormat:@"浏览%@次",model.leRunBrowse];
    cell.loveLabel.text = model.loveCount;
    [cell.loveBtn removeAllTargets];
    [[cell.loveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self loveAction:cell model:model];
    }];
    
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
    [self.navigationController pushViewController:dVC animated:YES];
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
