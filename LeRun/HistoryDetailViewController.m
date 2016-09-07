//
//  HistoryDetailViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/8/8.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//
#define PageSize @"10"

#import "HistoryDetailViewController.h"
#import "ShowTableViewCell.h"
#import "ShowCommentModel.h"
#import "HistoryHeader.h"
#import "MJRefresh.h"
#import "ShowCommentModel.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
//#import <IQKeyboardManager/IQKeyboardManager.h>
#import "IQKeyboardManager.h"
@interface HistoryDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation HistoryDetailViewController
{
    NSMutableArray *commentArray;//评论数组
    LeRunModel *leRunModel;
    HistoryHeader *headerView;
    int currentPage;//第多少页
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
//    [FuncPublic hideTabBar:self];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.view.frame = CGRectMake(0, 64, DEVW, DEVH-64);
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
//    [FuncPublic hideTabBar:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    commentArray = [NSMutableArray array];
    self.historyTableView.delegate = self;
    self.historyTableView.dataSource = self;
    self.historyTableView.estimatedRowHeight = 100;
    self.historyTableView.rowHeight = UITableViewAutomaticDimension;
    headerView = [[HistoryHeader alloc]init];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVW, 283)];
    headerView.frame = view.bounds;
    [view addSubview:headerView];
    self.historyTableView.tableHeaderView = view;
    //下拉刷新
    @weakify(self);
    [self.historyTableView addHeaderWithCallback:^{
        @strongify(self);
        currentPage = 1;
        [self getData:1];
    }];
    //上拉刷新
    [self.historyTableView addFooterWithCallback:^{
        @strongify(self);
        currentPage += 1;
        [self getData:currentPage];
    }];
    [self.historyTableView headerBeginRefreshing];//刷新
}
-(void)getData:(int)cp{
    //获取评论
    if(currentPage == 1){
        [self getHeader];
    }
    NSMutableArray *tempArray = [NSMutableArray array];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.leRunID forKey:@"lerun_id"];
    [params setObject:@"historylerun" forKey:FLAG];
    [params setObject:@"3" forKey:SERVER_INDEX];
    [params setObject:[NSString stringWithFormat:@"%d",cp] forKey:@"currentPage"];//页数
    [params setObject:PageSize forKey:@"pageSize"];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {//获取评论
        NSString *state = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]];
        NSArray *result = [responseObject objectForKey:@"datas"];
        if([state isEqualToString:@"1"]){
            for(int i = 0;i<result.count;i++){
                ShowCommentModel *model = [ShowCommentModel new];
                NSDictionary *dic = result[i];
                model.userHeader = [NSString stringWithFormat:@"%@/%@",BASE_URL,[dic objectForKey:@"user_header"]];
                model.userName = [dic objectForKey:@"user_name"];
                model.commentTime = [dic objectForKey:@"evaluate_time"];
                model.commentContent = [dic objectForKey:@"evaluate_content"];
                model.evaluateStar = [dic objectForKey:@"evaluate_star"];
                [tempArray addObject:model];
            }
            if(commentArray.count >= [PageSize intValue] && [self.historyTableView isFooterRefreshing]){
                commentArray = [commentArray arrayByAddingObjectsFromArray:tempArray];
            }
            else
                commentArray = tempArray;
            
            [self.historyTableView reloadData];
            if([self.historyTableView isFooterRefreshing])
               [self.historyTableView footerEndRefreshing];
            else
            [self.historyTableView headerEndRefreshing];
        }else if([state isEqualToString:@"0"]){
            [WToast showWithText:[responseObject objectForKey:@"datas"]];
            if([self.historyTableView isFooterRefreshing])
                [self.historyTableView footerEndRefreshing];
            else
                [self.historyTableView headerEndRefreshing];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {//失败
        if([self.historyTableView isFooterRefreshing])
            [self.historyTableView footerEndRefreshing];
        else
            [self.historyTableView headerEndRefreshing];
        [WToast showWithText:HTTP_FAIL];
    }];
}
-(void)getHeader{
    //获取头部
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    [params1 setObject:self.leRunID forKey:@"lerun_id"];
    [params1 setObject:@"historylerun" forKey:FLAG];
    [params1 setObject:@"2" forKey:SERVER_INDEX];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params1 success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *state = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]];
        NSDictionary *result = [responseObject objectForKey:@"datas"];
        if([state isEqualToString:@"1"]){
            leRunModel = [[LeRunModel alloc]init];
            leRunModel.posterImage = [NSString stringWithFormat:@"%@/%@",BASE_URL,[result objectForKey:@"lerun_poster"]];
            leRunModel.score = [[result objectForKey:@"AverageStar"] substringWithRange:NSMakeRange(0, 3)];
            leRunModel.leRunTitle = [result objectForKey:@"lerun_title"];
            leRunModel.leRunTime = [result objectForKey:@"lerun_time"];
            leRunModel.leRunContent = [result objectForKey:@"lerun_content"];
            leRunModel.leRunHost = [result objectForKey:@"lerun_host"];
            leRunModel.leRunMaxUser = [result objectForKey:@"lerun_maxuser"];
            headerView.model = leRunModel;
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [WToast showWithText:HTTP_FAIL];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return commentArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell4";
    ShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"CommentCell" bundle:nil];
        cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ShowCommentModel *model = commentArray[indexPath.row];
    [cell.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:model.userHeader] placeholderImage:[UIImage imageNamed:@"home.jpg"]];
    cell.userNameLabel.text = model.userName;
    cell.contentLabel.text = model.commentContent;
    cell.timeLabel.text = model.commentTime;
    if([model.evaluateStar intValue] > 0){
        cell.commentCountLabel.text = @"活动评价";
    }
    
    return cell;
}
- (IBAction)sendAction:(id)sender {//回复
    [self.view endEditing:YES];
    [self sendComment];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendComment];
    [textField resignFirstResponder];
    return YES;
}
-(void)sendComment{
    if([self.inputTextView.text isEqualToString:@""] || self.inputTextView.text == nil){
        [WToast showWithText:SETNULL];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"historylerun" forKey:FLAG];
    [params setObject:@"4" forKey:SERVER_INDEX];
    if([FuncPublic isNilOrEmpty:[FuncPublic GetDefaultInfo:USER_ID]]){
        LoginViewController *lVC = [LoginViewController new];
        [WToast showWithText:@"请先登录!"];
        lVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lVC animated:YES];
        return;
    }
    [params setObject:[FuncPublic GetDefaultInfo:USER_ID] forKey:@"user_id"];
    [params setObject:self.inputTextView.text forKey:@"evaluate_content"];
    [params setObject:self.leRunID forKey:@"lerun_id"];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *state = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]];
        if([state isEqualToString:@"1"]){
            [self.historyTableView headerBeginRefreshing];
            self.inputTextView.text = @"";
            [WToast showWithText:@"评论成功"];
        }else{
            [WToast showWithText:@"评论失败"];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [WToast showWithText:HTTP_FAIL];
    }];

}
- (void)keyboardWillShow:(NSNotification *)notif {
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    CGRect tempRect = self.view.frame;
    tempRect.origin.y = tempRect.origin.y - keyboardSize.height;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = tempRect;
        [self.view setNeedsDisplay];
    }];
}

- (void)keyboardShow:(NSNotification *)notif {
    
}

- (void)keyboardWillHide:(NSNotification *)notif {
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    CGRect tempRect = self.view.frame;
    tempRect.origin.y = tempRect.origin.y + keyboardSize.height;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = tempRect;
        [self.view setNeedsDisplay];
    }];
}

- (void)keyboardHide:(NSNotification *)notif {
    
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
