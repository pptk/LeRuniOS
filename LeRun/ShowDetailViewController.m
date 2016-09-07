//
//  ShowDetailViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/19.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//


#import "ShowDetailViewController.h"
#import "ShowTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "ShowCommentModel.h"
#import "ShowLoveModel.h"
#import "LoginViewController.h"
#import "LoveDetailViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ShareSDK/ShareSDK.h>
#import "IQKeyboardManager.h"
#define IMAGEWIDTH 35
@interface ShowDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@end

@implementation ShowDetailViewController
{
    NSMutableArray *commentArray;//评论数组
    NSMutableArray *loveArray;
}
#pragma mark 取消IQKeyboardManager
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
    [self.view bringSubviewToFront:self.bottomView];
    return self;
}
-(void)viewWillDisappear:(BOOL)animated{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"详情";
//    self.automaticallyAdjustsScrollViewInsets = NO;
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
    
    
    
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"..." style:UIBarButtonItemStylePlain target:self action:@selector()];

    UIButton *rightbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [rightbtn setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(shareWithShareMenuOnly) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItme = [[UIBarButtonItem alloc]initWithCustomView:rightbtn];
    self.navigationItem.rightBarButtonItem = rightBarItme;
    
    self.showTableView.delegate = self;
    self.showTableView.dataSource = self;
    
    commentArray = [NSMutableArray array];
    loveArray = [NSMutableArray array];
    
    self.showTableView.estimatedRowHeight = 100;
    self.showTableView.rowHeight = UITableViewAutomaticDimension;
    self.showTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.showTableView.showsVerticalScrollIndicator = NO;
    @weakify(self);
    [self.showTableView addHeaderWithCallback:^{
        @strongify(self);
        [self getData:NO];
    }];
    [self getData:YES];
    //    self.inputTextField
    self.inputTextField.delegate = self;
}
-(void)shareWithShareMenuOnly{
    [FuncPublic shareWithShareMenuOnly:self haveReport:YES];
}
#pragma mark inputTextField 
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeyDone;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendComment];
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)sendCommentAction:(id)sender {
//    [self ]
    [self.view endEditing:YES];
    [self sendComment];
}
-(void)sendComment{
    NSString *str = [self.inputTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if([str isEqualToString:@""] || str == nil){
        [WToast showWithText:SETNULL];
        return;
    }
    if(str.length >500){
        [WToast showWithText:@"文本太长了哦，请减少到500字以内"];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"show" forKey:FLAG];
    [params setObject:@"7" forKey:SERVER_INDEX];
    [params setObject:self.model.showID forKey:@"show_id"];
    if([FuncPublic isNilOrEmpty:[FuncPublic GetDefaultInfo:USER_ID]]){
        LoginViewController *lVC = [LoginViewController new];
        [WToast showWithText:@"请先登录!"];
        lVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lVC animated:YES];
        return;
    }
    [params setObject:[FuncPublic GetDefaultInfo:USER_ID] forKey:@"user_id"];
    [params setObject:self.inputTextField.text forKey:@"comment_content"];
    [params setObject:self.model.userID forKey:@"comment_userid"];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *state = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]];
        if([state isEqualToString:@"1"]){
            [self.showTableView headerBeginRefreshing];
            self.inputTextField.text = @"";
            [WToast showWithText:@"评论成功"];
        }else{
            [WToast showWithText:@"评论失败"];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [WToast showWithText:HTTP_FAIL];
    }];
}

#pragma mark getdata
-(void)getData:(BOOL)show{
    //根据秀的ID查找点赞和评论列表
    NSMutableArray *tempArray = [NSMutableArray array];
    NSMutableArray *tempArraylove = [NSMutableArray array];
    NSMutableDictionary *paramsComment = [NSMutableDictionary dictionary];
    [paramsComment setValue:@"show" forKey:FLAG];
    [paramsComment setValue:@"4" forKey:SERVER_INDEX];
    [paramsComment setValue:self.model.showID forKey:@"show_id"];
    MBProgressHUD *hud;
    if(show){
        hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
    }
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:paramsComment success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if(show){
            [FuncPublic HideHud:hud animating:YES];
        }
        if([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]] isEqualToString:@"1"]){
            NSArray *resultArray = [responseObject objectForKey:@"datas"];
            for(int i = 0;i<resultArray.count;i++){
                ShowCommentModel *model = [ShowCommentModel new];
                model.commentContent = [resultArray[i] objectForKey:@"comment_content"];
                model.commentTime = [resultArray[i] objectForKey:@"comment_time"];
                model.userName = [resultArray[i] objectForKey:@"user_name"];
                model.userHeader = [NSString stringWithFormat:@"%@/%@",BASE_URL,[resultArray[i] objectForKey:@"user_header"]];
                model.userID = [resultArray[i] objectForKey:@"user_id"];
                model.commentID = [resultArray[i] objectForKey:@"comment_id"];
                [tempArray addObject:model];
            }
            commentArray = tempArray;
            [self.showTableView reloadData];
            [self.showTableView headerEndRefreshing];
        }else{
            [self.showTableView headerEndRefreshing];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if(show){
            [FuncPublic HideHud:hud animating:YES];
        }
        [WToast showWithText:HTTP_FAIL];
        [self.showTableView headerEndRefreshing];
    }];
    NSMutableDictionary *paramsLove = [NSMutableDictionary dictionary];
    [paramsLove setValue:@"show" forKey:FLAG];
    [paramsLove setValue:@"5" forKey:SERVER_INDEX];
    [paramsLove setValue:self.model.showID forKey:@"show_id"];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:paramsLove success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]] isEqualToString:@"1"]){
            NSArray *resultArray = [responseObject objectForKey:@"datas"];
            for(int i = 0;i<resultArray.count;i++){
                ShowLoveModel *model = [ShowLoveModel new];
                model.userTime = [resultArray[i] objectForKey:@"user_time"];
                model.userID = [resultArray[i] objectForKey:@"user_id"];
                model.userName = [resultArray[i] objectForKey:@"user_name"];
                model.userHeader = [NSString stringWithFormat:@"%@/%@",BASE_URL,[resultArray[i] objectForKey:@"user_header"]];
                [tempArraylove addObject:model];
            }
            loveArray = tempArraylove;
            [self.showTableView reloadData];
        }else{
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [WToast showWithText:HTTP_FAIL];
    }];
}

#pragma mark delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return commentArray.count + 2;//第一行为内容，第二行为点赞，之后的为评论。
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0 && self.model.imageArray.count == 0){//没图的时候显示。
        static NSString *identifier = @"cell1";
        ShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil){
            UINib *nib = [UINib nibWithNibName:@"DetailImageCell" bundle:nil];
            cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userNameLabel.text = self.model.userName;
        [cell.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:self.model.userHeader] placeholderImage:[UIImage imageNamed:@"default_avtar.jpg"]];
        cell.contentLabel.text = self.model.showContent;
        cell.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        return cell;
    }else if(indexPath.row == 0 && self.model.imageArray.count > 0){//有图的时候显示
        static NSString *identifier = @"cell2";
        ShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil){
            UINib *nib = [UINib nibWithNibName:@"DetailImageHaveCell" bundle:nil];
            cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageArray = self.model.imageArray;
        cell.userNameLabel.text = self.model.userName;
        [cell.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:self.model.userHeader] placeholderImage:[UIImage imageNamed:@"default_avtar.jpg"]];
        cell.contentLabel.text = self.model.showContent;
        cell.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        return cell;
    }else if(indexPath.row == 1){//点赞头像
        static NSString *identifier = @"cell3";
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *leftHeart = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 25, 25)];
        leftHeart.image = [UIImage imageNamed:@"show_heart.png"];
        [cell.contentView addSubview:leftHeart];
        for(int i = 0;i<(DEVW-45-60)/45 && i< loveArray.count;i++){
            ShowLoveModel *loveModel = loveArray[i];
            UIImageView *headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(45+IMAGEWIDTH*i+10*(i+1),(45-IMAGEWIDTH)/2, IMAGEWIDTH, IMAGEWIDTH)];
            [headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",loveModel.userHeader]] placeholderImage:[UIImage imageNamed:@"default_avtar.jpg"]];
            headerImageView.layer.cornerRadius = IMAGEWIDTH/2;
            headerImageView.layer.masksToBounds = YES;
            headerImageView.contentMode = UIViewContentModeScaleAspectFill;
            [cell.contentView addSubview:headerImageView];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{//评论列表
        static NSString *identifier = @"cell4";
        ShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ShowCommentModel *commentModel = commentArray[indexPath.row - 2];
        if(cell == nil){
            UINib *nib = [UINib nibWithNibName:@"CommentCell" bundle:nil];
            cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:commentModel.userHeader] placeholderImage:[UIImage imageNamed:@"default_avtar.jpg"]];
        cell.userHeaderImageView.layer.cornerRadius = 20;
        cell.userHeaderImageView.layer.masksToBounds = YES;
        cell.userNameLabel.text = commentModel.userName;
        cell.timeLabel.text = commentModel.commentTime;
        cell.contentLabel.text = commentModel.commentContent;
        cell.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 1){
        LoveDetailViewController *lDVC = [LoveDetailViewController new];
        lDVC.showID = self.model.showID;
        lDVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lDVC animated:YES];
    }
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
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;
    if(indexPath.row >= 2){
        result = UITableViewCellEditingStyleDelete;
    }
    return result;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowCommentModel *model = commentArray[indexPath.row-2];
    if([model.userID isEqualToString:[FuncPublic GetDefaultInfo:USER_ID]]){
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"show" forKey:FLAG];
        [params setObject:@"9" forKey:SERVER_INDEX];
        [params setObject:model.commentID forKey:@"comment_id"];
        MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
        [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            [FuncPublic HideHud:hud animating:YES];
            NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]];
            if([status isEqualToString:@"1"]){//删除成功
                [commentArray removeObjectAtIndex:indexPath.row - 2];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                [WToast showWithText:@"删除失败"];
            }
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            [WToast showWithText:HTTP_FAIL];
        }];
    }else{
        [WToast showWithText:@"只能删除自己的评论哦~"];
    }
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
