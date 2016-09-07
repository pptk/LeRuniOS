//
//  MyShowViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/23.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//
#import "MyShowViewController.h"
#import "ShowTableViewCell.h"
#import "ShowModel.h"
#import "UIImageView+WebCache.h"
#import "UIControl+PengXiongHui.h"
#import <Reactivecocoa/Reactivecocoa.h>
#import "MJRefresh.h"
#import "ShowDetailViewController.h"
@interface MyShowViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyShowViewController
{
    NSMutableArray *showArray;
    CATextLayer *textLayer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [FuncPublic hideTabBar:self];
    self.navigationItem.title = @"我的秀";
    
    self.tableViews.delegate = self;
    self.tableViews.dataSource = self;
    self.tableViews.estimatedRowHeight = 100;
    self.tableViews.rowHeight = UITableViewAutomaticDimension;
    
    showArray = [NSMutableArray array];
    @weakify(self);
    [self.tableViews addHeaderWithCallback:^{
        @strongify(self);
        [self getData];
    }];
    [self.tableViews headerBeginRefreshing];
}
-(void)getData{
    NSMutableArray *tempArray = [NSMutableArray array];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"show" forKey:FLAG];
    [params setObject:@"3" forKey:SERVER_INDEX];
    if(![FuncPublic isNilOrEmpty:[FuncPublic GetDefaultInfo:USER_ID]]){
        [params setObject:[FuncPublic GetDefaultInfo:USER_ID] forKey:@"user_id"];
    }
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        self.tableViews.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        NSArray *array = [responseObject objectForKey:@"result"];
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
            showArray = tempArray;
            [self.tableViews headerEndRefreshing];
        [textLayer removeFromSuperlayer];
        [self.tableViews reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [WToast showWithText:HTTP_FAIL];
        [self.tableViews headerEndRefreshing];
        if(showArray.count == 0){
            self.tableViews.separatorStyle = UITableViewCellSeparatorStyleNone;
            textLayer = [CATextLayer layer];
            textLayer.frame = CGRectMake(0, DEVH/3, DEVW, DEVH);
            [self.tableViews.layer addSublayer:textLayer];
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

#pragma mark
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return showArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowModel *model = showArray[indexPath.row];
    if(model.imageArray.count == 0){
        static NSString *identifier = @"shownoimagecell";
        ShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil){
            UINib *nib = [UINib nibWithNibName:@"DetailImageCell" bundle:nil];
            cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tag = indexPath.row+1008;
        [cell.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:model.userHeader] placeholderImage:[UIImage imageNamed:@"home.jpg"]];
        cell.userNameLabel.text = model.userName;
        cell.contentLabel.text = model.showContent;
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
            UINib *nib = [UINib nibWithNibName:@"DetailImageHaveCell" bundle:nil];
            cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tag = indexPath.row+1008;
        [cell.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:model.userHeader] placeholderImage:[UIImage imageNamed:@"home.jpg"]];
        cell.userNameLabel.text = model.userName;
        cell.contentLabel.text = model.showContent;
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
    ShowDetailViewController *sdVC = [ShowDetailViewController new];
    sdVC.model = showArray[indexPath.row];
    sdVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sdVC animated:YES];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowModel *model = showArray[indexPath.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"show" forKey:FLAG];
    [params setObject:@"1" forKey:SERVER_INDEX];
    [params setObject:model.showID forKey:@"show_id"];
    MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
    [[FuncPublic getAFNetManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [FuncPublic HideHud:hud animating:YES];
        NSData *data = (NSData *)responseObject;
        NSString *state = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if([state  isEqualToString:@"1"]){
            [showArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FuncPublic HideHud:hud animating:YES];
        [WToast showWithText:HTTP_FAIL];
    }];
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
