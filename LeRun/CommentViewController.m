//
//  CommentViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/8/11.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()

@end

@implementation CommentViewController
{
    UIButton *selectedBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"评价";
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (IBAction)sendCommentAction:(id)sender {
    if([FuncPublic isNilOrEmpty:self.commentTextField.text]){
        [WToast showWithText:SETNULL];
        return;
    }
    if([FuncPublic isNilOrEmpty:[FuncPublic GetDefaultInfo:USER_ID]]){
        [WToast showWithText:NO_LOGIN];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"lerun" forKey:FLAG];
    [params setObject:@"12" forKey:SERVER_INDEX];
    [params setObject:[FuncPublic GetDefaultInfo:USER_ID] forKey:@"user_id"];
    [params setObject:self.commentTextField.text forKey:@"evaluate_content"];
    [params setObject:self.leRunID forKey:@"lerun_id"];
    [params setObject:self.telPhone forKey:@"user_telphone"];
    MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
    [params setObject:[NSString stringWithFormat:@"%ld",selectedBtn.tag-1000] forKey:@"evaluate_star"];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [FuncPublic HideHud:hud animating:YES];
        NSString *state = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]];
        if([state isEqualToString:@"1"]){
            [WToast showWithText:@"评价成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [WToast showWithText:@"评价失败"];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FuncPublic HideHud:hud animating:YES];
        [WToast showWithText:HTTP_FAIL];
    }];
}
- (IBAction)startAction:(id)sender {
    selectedBtn = (UIButton *)sender;
    for(int i = 0;i<5;i++){
        NSString *proStr = [NSString stringWithFormat:@"StarBtn%d",i+1];
        UIButton *btn = [self valueForKey:proStr];
        btn.selected = NO;
    }
    for(int i = 0;i<selectedBtn.tag-1000;i++){
        NSString *proStr = [NSString stringWithFormat:@"StarBtn%d",i+1];
        UIButton *btn = [self valueForKey:proStr];
        btn.selected = YES;
    }
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
