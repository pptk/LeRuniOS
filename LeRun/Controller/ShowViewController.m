//
//  ShowViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/5.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#define pageSize 10

#import "ShowViewController.h"
#import "ShowTableViewCell.h"
#import "ShowModel.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "ShowDetailViewController.h"
#import "SendViewController.h"
#import "UIControl+PengXiongHui.h"
#import "ShowSearchViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface ShowViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation ShowViewController
{
    NSMutableArray *ShowArray;
    int currentPage;
    CATextLayer *textLayer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNav];
    [self createTableView];
    currentPage = 1;
}
-(void)createNav{
    [self.navigationController.navigationBar    setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];//设置文字白色
    self.navigationItem.title = @"秀";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];//设置返回为白色
}
-(void)createTableView{
    self.showTableView.delegate = self;
    self.showTableView.dataSource = self;
    self.showTableView.estimatedRowHeight = 100;
    self.showTableView.rowHeight = UITableViewAutomaticDimension;
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, DEVW, 35)];
    searchBar.barTintColor = RGB(245, 245, 245);
    [searchBar setBackgroundImage:[UIImage new]];
    [searchBar setBackgroundColor:RGB(245, 245, 245)];
    searchBar.placeholder = @"搜索秀";
    searchBar.delegate = self;
    UIButton *control = [[UIButton alloc]initWithFrame:searchBar.bounds];
    [searchBar addSubview:control];
    [control addTarget:self action:@selector(searchBarAction:) forControlEvents:UIControlEventTouchUpInside];
    self.showTableView.tableHeaderView = searchBar;
    ShowArray = [NSMutableArray array];
    @weakify(self);
    [self.showTableView addHeaderWithCallback:^{
        @strongify(self);
        currentPage = 1;
        [self getData];
    }];
    [self.showTableView headerBeginRefreshing];
    [self.showTableView addFooterWithCallback:^{
        @strongify(self);
        currentPage += 1;
        [self getData];
    }];
}
-(void)searchBarAction:(id)sender{
    ShowSearchViewController *ssVC = [ShowSearchViewController new];
    [self.navigationController pushViewController:ssVC animated:YES];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return NO;
}
-(void)getData{
    NSMutableArray *tempArray = [NSMutableArray array];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"show" forKey:FLAG];
    [params setObject:@"2" forKey:SERVER_INDEX];
    [params setObject:[NSString stringWithFormat:@"%d",pageSize] forKey:@"pageSize"];
    if(![FuncPublic isNilOrEmpty:[FuncPublic GetDefaultInfo:USER_ID]]){
        [params setObject:[FuncPublic GetDefaultInfo:USER_ID] forKey:@"user_id"];
    }
    [params setObject:[NSString stringWithFormat:@"%d",currentPage] forKey:@"currentPage"];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        self.showTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        NSString *state = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]];
        if([state isEqualToString:@"1"]){
            NSArray *array = [responseObject objectForKey:@"datas"];
            for(int i = 0;  i<array.count;i++){
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
        }else{
            if([FuncPublic isNilOrEmpty:[responseObject objectForKey:@"datas"]]){
                [WToast showWithText:[responseObject objectForKey:@"datas"]];
            }
        }
        if([self.showTableView isFooterRefreshing]){
            ShowArray = [ShowArray arrayByAddingObjectsFromArray:tempArray];
            [self.showTableView footerEndRefreshing];
        }else{
            ShowArray = tempArray;
            [self.showTableView headerEndRefreshing];
        }
        [textLayer removeFromSuperlayer];
        [self.showTableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [WToast showWithText:HTTP_FAIL];
        if([self.showTableView isHeaderRefreshing])
            [self.showTableView headerEndRefreshing];
        else
            [self.showTableView footerEndRefreshing];
        if(ShowArray.count == 0){
            self.showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            if(!textLayer){
                textLayer = [CATextLayer layer];
            }
            textLayer.frame = CGRectMake(0, DEVH/3, DEVW, DEVH);
            [self.showTableView.layer addSublayer:textLayer];
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
        }
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ShowArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowModel *model = ShowArray[indexPath.row];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShowDetailViewController *sdVC = [[ShowDetailViewController alloc]init];
    sdVC.model = ShowArray[indexPath.row];
    sdVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sdVC animated:YES];
}
- (IBAction)sendShow:(id)sender {
    SendViewController *sVC = [[SendViewController alloc]init];
    sVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sVC animated:YES];
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
