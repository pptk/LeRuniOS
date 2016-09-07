//
//  LoveDetailViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/8/10.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "LoveDetailViewController.h"
#import "ShowLoveModel.h"
#import "UIImageView+WebCache.h"
@interface LoveDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LoveDetailViewController
{
    NSMutableArray *loveArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"点赞";
    self.loveTableView.delegate = self;
    self.loveTableView.dataSource = self;
    
    loveArray = [NSMutableArray array];
    [self getData];
}
-(void)getData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"5" forKey:SERVER_INDEX];
    [params setObject:self.showID forKey:@"show_id"];
    [params setObject:@"show" forKey:FLAG];
    MBProgressHUD *hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:ISLOADING];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *state = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]];
        if([state isEqualToString:@"1"]){
            NSArray *result = [responseObject objectForKey:@"datas"];
            for(int i = 0;i<result.count;i++){
                ShowLoveModel *model = [ShowLoveModel new];
                model.userHeader = [result[i] objectForKey:@"user_header"];
                model.userName = [result[i] objectForKey:@"user_name"];
                model.userTime = [result[i] objectForKey:@"like_time"];
                [loveArray addObject:model];
            }
            [self.loveTableView reloadData];
        }else if([state isEqualToString:@"0"]){
            [WToast showWithText:@"还没有人点赞哦"];
        }
        [FuncPublic HideHud:hud animating:YES];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FuncPublic HideHud:hud animating:YES];
        [WToast showWithText:[NSString stringWithFormat:@"错误:%@",error]];
    }];
}
#pragma mark tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return loveArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *loveCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(loveCell == nil){
        loveCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    ShowLoveModel *model = loveArray[indexPath.row];
    loveCell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [loveCell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",BASE_URL,model.userHeader]] placeholderImage:[UIImage imageNamed:@"default_avtar.jpg"]];
    loveCell.textLabel.text = model.userName;
    loveCell.detailTextLabel.text = model.userTime;
    return loveCell;
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
