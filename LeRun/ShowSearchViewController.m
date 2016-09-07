//
//  ShowSearchViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/9/6.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "ShowSearchViewController.h"
#import "ShowModel.h"
#import "FMDB.h"
#import "ShowTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIControl+PengXiongHui.h"
#import "ShowDetailViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface ShowSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>

@end

@implementation ShowSearchViewController
{
    NSMutableArray *searchHistoryArray;
    NSMutableArray *searchResultArray;
    BOOL showResult;
    FMDatabase* db;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self.searchBar setBackgroundImage:[UIImage new]];
    self.searchBar.showsCancelButton = YES;
    [self.searchBar becomeFirstResponder];
    //    self.searchBar.barTintColor = [UIColor redColor];
    [self.searchBar setBackgroundColor:RGB(245, 245, 245)];
    self.searchBar.placeholder = @"搜索秀";
    self.searchBar.delegate = self;
    [self createTableView];
    self.navigationController.delegate = self;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([FuncPublic isNilOrEmpty:searchText]){
        showResult = NO;
        [self.resultTableView reloadData];
    }else{
        showResult = YES;
        [self.resultTableView reloadData];
    }
}
//隐藏导航条
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}
//初始化TableView
-(void)createTableView{
    [self getSearchHistory];
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
    self.resultTableView.estimatedRowHeight = 100;
    self.resultTableView.rowHeight = UITableViewAutomaticDimension;
}
//搜索按钮事件
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [db executeUpdate:@"INSERT INTO searchhistory (content) VALUES (?);",searchBar.text];//添加内容到历史记录
    [self searchBlock:searchBar];
}
//查询操作
-(void)searchBlock:(UISearchBar*)searchBar{
    [self.searchBar resignFirstResponder];
    NSMutableArray *tempArray = [NSMutableArray array];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"show" forKey:FLAG];
    [params setObject:@"10" forKey:SERVER_INDEX];
    [params setObject:searchBar.text forKey:@"search_content"];
    [params setObject:[FuncPublic GetDefaultInfo:USER_ID]?[FuncPublic GetDefaultInfo:USER_ID]:@"" forKey:@"user_id"];
    MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [FuncPublic HideHud:hud animating:YES];
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]];
        if([status isEqualToString:@"1"]){
            NSArray *array = [responseObject objectForKey:@"datas"];
            for(int i = 0;i<array.count;i++){
                ShowModel *model = [[ShowModel alloc]init];
                model.showCommentCount = [NSString stringWithFormat:@"%@",[array[i] objectForKey:@"comment_num"]];//评论的次数
                model.showLoveCount = [NSString stringWithFormat:@"%@",[array[i] objectForKey:@"like_num"]];
                NSString *loveState = [NSString stringWithFormat:@"%@",[array[i] objectForKey:@"like_state"]];
                if([loveState isEqualToString:@"1"]){
                    model.isLove = YES;
                }else{
                    model.isLove = NO;
                }
                model.showContent = [array[i] objectForKey:@"show_content"];
                model.showID = [NSString stringWithFormat:@"%@",[array[i] objectForKey:@"show_id"]];
                model.userHeader = [NSString stringWithFormat:@"%@/%@",BASE_URL,[array[i] objectForKey:@"user_header"]];
                model.userName = [array[i] objectForKey:@"user_name"];
                model.showTime = [array[i] objectForKey:@"show_time"];
                
                NSString *showImageStr = [array[i] objectForKey:@"show_image"];
                NSArray *showImageArray = [NSJSONSerialization JSONObjectWithData:[showImageStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];//图片
                NSMutableArray *imagetempArray = [NSMutableArray array];
                for(int i = 0;i<showImageArray.count;i++){
                    NSString *imageURL = [NSString stringWithFormat:@"%@/%@",BASE_URL,[showImageArray[i] objectForKey:@"imagePath"]];
                    [imagetempArray addObject:imageURL];
                }
                model.imageArray = imagetempArray;
                model.userID = [array[i] objectForKey:@"user_id"];
                [tempArray addObject:model];
            }
            searchResultArray = tempArray;
            showResult = YES;//显示查询结果
            [self.resultTableView reloadData];
        }else{
            [WToast showWithText:@"搜索失败~"];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FuncPublic HideHud:hud animating:YES];
        [WToast showWithText:HTTP_FAIL];
        NSLog(@"----%@",error);
    }];
    
}
//获取搜索历史记录
-(void)getSearchHistory{
    searchHistoryArray = [NSMutableArray array];
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:@"lerun.sqlite"];
    db = [FMDatabase databaseWithPath:dbpath];
    if([db open]){
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS searchhistory(id integer primary key autoincrement,content text NOT NULL);"];
        if(!result){
            [WToast showWithText:@"获取搜索历史失败"];
        }
    }
    FMResultSet *resultSet = [db executeQuery:@"select * from searchhistory where id in (select id from searchhistory group by content) order by id desc;"];//去重加倒序
    while ([resultSet next]) {
        NSString *content = [resultSet objectForColumnName:@"content"];
        [searchHistoryArray addObject:content];
    }
}
#pragma mark delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(!showResult){
        return searchHistoryArray.count+1;//显示历史查询记录
    }else{
        return searchResultArray.count;//显示搜索结果
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!showResult){//显示历史查询记录
        static NSString *identifier = @"historycell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        if(indexPath.row == searchHistoryArray.count){//如果是最后一行
            if(searchHistoryArray.count == 0){
                cell.textLabel.text = @"没有查询记录";
            }else{
                cell.textLabel.text = @"清空查询记录";
            }
            cell.textLabel.textColor = RGB(188, 188, 188);
        }else{
            cell.textLabel.text = searchHistoryArray[indexPath.row];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{//显示搜索结果
        ShowModel *model = searchResultArray[indexPath.row];
        if(model.imageArray.count == 0){
            static NSString *identifier = @"noimagecell";
            ShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(cell == nil){
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"searchShow" owner:nil options:nil];
                cell = array[0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.tag = indexPath.row+1008;
            [cell.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:model.userHeader] placeholderImage:[UIImage imageNamed:@"default_avtar.jpg"]];
            cell.userNameLabel.text = model.userName;
            cell.contentLabel.text = model.showContent;
            cell.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
            cell.timeLabel.text = model.showTime;
            cell.loveCountLabel.text = model.showLoveCount;
            cell.commentCountLabel.text = model.showCommentCount;
            if(model.isLove)
                cell.loveBtn.selected = YES;
            else
                cell.loveBtn.selected = NO;
            [cell.loveBtn removeAllTargets];
            [[cell.loveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                [self loveAction:cell showModel:model];
            }];
            return cell;
        }else{
            static NSString *identifier = @"showimagecell";
            ShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(cell == nil){
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"searchImageShow" owner:nil options:nil];
                cell = array[0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.tag = indexPath.row+1008;
            [cell.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:model.userHeader] placeholderImage:[UIImage imageNamed:@"default_avtar.jpg"]];
            cell.userNameLabel.text = model.userName;
            cell.contentLabel.text = model.showContent;
            cell.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
            cell.timeLabel.text = model.showTime;
            cell.loveCountLabel.text = model.showLoveCount;
            cell.commentCountLabel.text = model.showCommentCount;
            cell.imageArray = model.imageArray;
            if(model.isLove)
                cell.loveBtn.selected = YES;
            else
                cell.loveBtn.selected = NO;
            
            [cell.loveBtn removeAllTargets];
            [[cell.loveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                [self loveAction:cell showModel:model];
            }];
            
            UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
            [cell.shareBtn addGestureRecognizer:tap];
            [[tap rac_gestureSignal] subscribeNext:^(id x) {
                [FuncPublic shareWithShareMenuOnly:self haveReport:NO];
            }];
            return cell;
        }
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(!showResult){//显示的是历史记录,清空历史记录
        if(indexPath.row == searchHistoryArray.count){
            searchHistoryArray = [NSMutableArray array];
            [db executeUpdate:@"delete from searchhistory where 1=1"];
            [self.resultTableView reloadData];
        }else{
            self.searchBar.text = searchHistoryArray[indexPath.row];
            [self searchBlock:self.searchBar];
        }
    }else{
        ShowDetailViewController *sdVC = [[ShowDetailViewController alloc]init];
        sdVC.model = searchResultArray[indexPath.row];
        sdVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sdVC animated:NO];
    }
}
//点赞事件
-(void)loveAction:(ShowTableViewCell *)cell showModel:(ShowModel *)model{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"show" forKey:FLAG];
    [params setValue:model.showID forKey:@"show_id"];
    if(cell.loveBtn.selected == NO){
        [params setValue:model.userID forKey:@"like_userid"];
        [params setValue:@"8" forKey:SERVER_INDEX];
    }else{
        [params setValue:@"6" forKey:SERVER_INDEX];
    }
    if([FuncPublic isNilOrEmpty:[FuncPublic GetDefaultInfo:USER_ID]]){
        [WToast showWithText:@"请先登录哦~"];
        return;
    }
    [params setValue:[FuncPublic GetDefaultInfo:USER_ID] forKey:@"user_id"];
    MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]] isEqualToString:@"1"]){
            [FuncPublic HideHud:hud animating:YES];
            [WToast showWithText:@"操作成功~"];
            if(cell.loveBtn.selected == YES){
                cell.loveBtn.selected = !cell.loveBtn.selected;
                cell.loveCountLabel.text = [NSString stringWithFormat:@"%d",[cell.loveCountLabel.text intValue] - 1];
                model.isLove = !model.isLove;
                model.showLoveCount = cell.loveCountLabel.text;
            }else{
                cell.loveBtn.selected = !cell.loveBtn.selected;
                cell.loveCountLabel.text = [NSString stringWithFormat:@"%d",[cell.loveCountLabel.text intValue] + 1];
                model.isLove = !model.isLove;
                model.showLoveCount = cell.loveCountLabel.text;
            }
        }else{
            [FuncPublic HideHud:hud animating:YES];
            [WToast showWithText:@"操作失败~"];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FuncPublic HideHud:hud animating:YES];
        [WToast showWithText:HTTP_FAIL];
    }];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.navigationController popViewControllerAnimated:YES];
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
