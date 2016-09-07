//
//  FluorescenceViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/17.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "FluorescenceViewController.h"
#import "ThemeViewController.h"
#import "HistoryChildViewController.h"
#import "UIImageView+WebCache.h"
#import "LeRunModel.h"
#import "MJRefresh.h"
#import "HistoryDetailViewController.h"
@interface FluorescenceViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *historyTableView;
    NSMutableArray *historyArray;
}

@end

@implementation FluorescenceViewController
{
    CATextLayer *textLayer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if([self.parentViewController isKindOfClass:[ThemeViewController class]]){
//        [FuncPublic hideTabBar:self];
        self.view.backgroundColor = RGB(205, 205, 205);
        [self CreateFluo];
    }else if([self.parentViewController isKindOfClass:[HistoryChildViewController class]]){
        self.view.backgroundColor = RGB(205, 205, 205);
        [self createHistory];
    }
}
-(void)CreateFluo{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, DEVW, 20)];
    label.text = @"网页由www.jxkuafu.com提供";
    [label setTextColor:RGB(128, 128, 128)];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0.5, DEVW, DEVH-64-40-0.5)];
    webView.backgroundColor = [UIColor clearColor];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"ColorRun" ofType:@"html"];
    NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:htmlCont baseURL:baseURL];
    [self.view addSubview:webView];
}
-(void)createHistory{
    historyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0.5, DEVW, DEVH-64)];
    historyTableView.delegate = self;
    historyTableView.dataSource = self;
    historyTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVW, 84)];
    [self.view addSubview:historyTableView];
    historyArray = [NSMutableArray array];
    @weakify(self);
    [historyTableView addHeaderWithCallback:^{
        @strongify(self);
        [self getHistory];
    }];
    [historyTableView headerBeginRefreshing];
}
-(void)getHistory{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"historylerun" forKey:FLAG];
    [params setObject:@"1" forKey:SERVER_INDEX];
    [params setObject:@"5" forKey:@"lerun_theme"];
    NSMutableArray *tempArray = [NSMutableArray array];
    [[FuncPublic getAFNetJSONManager] POST:CHANGE_PERSON_INFOMATION parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //成功
        NSString *state = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]];
        if([state isEqualToString:@"1"]){
            NSArray *array = [responseObject objectForKey:@"datas"];
            for(int i = 0;i<array.count;i++){
                LeRunModel *model = [[LeRunModel alloc]init];
                model.leRunID = [NSString stringWithFormat:@"%@",[array[i] objectForKey:@"lerun_id"]];
                model.posterImage = [NSString stringWithFormat:@"%@/%@",BASE_URL,[array[i] objectForKey:@"lerun_poster"]];
                model.leRunTitle = [NSString stringWithFormat:@"%@",[array[i] objectForKey:@"lerun_title"]];
                model.leRunTime = [NSString stringWithFormat:@"%@",[array[i] objectForKey:@"lerun_time"]];
                model.leRunAddress = [NSString stringWithFormat:@"%@",[array[i] objectForKey:@"lerun_address"]];;
                [tempArray addObject:model];
            }
        }else if([state isEqualToString:@"0"]){
            [WToast showWithText:@"还没有回顾哦~"];
            [historyTableView headerEndRefreshing];
            [self haveNoHistory:@"还没有回顾哦~"];
            return;
        }
        [textLayer removeFromSuperlayer];
        historyArray = tempArray;
        [historyTableView reloadData];
        [historyTableView headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [historyTableView headerEndRefreshing];
        [self haveNoHistory:@"网络无法连接..."];
        [WToast showWithText:HTTP_FAIL];
    }];
}
-(void)haveNoHistory:(NSString *)state{
    if(textLayer){
        [textLayer removeFromSuperlayer];
    }
    textLayer = [CATextLayer layer];
    textLayer.frame = CGRectMake(0, DEVH*5/12, DEVW, DEVH);
    [historyTableView.layer addSublayer:textLayer];
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.wrapped = YES;
    UIFont *font = [UIFont systemFontOfSize:20];
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    textLayer.string = state;
    textLayer.foregroundColor = RGB(188, 188, 188).CGColor;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView isKindOfClass:[historyTableView class]]){
        return 200;
    }else{
        return 0;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView isKindOfClass:[historyTableView class]]){
        return historyArray.count;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView isKindOfClass:[historyTableView class]]){
        static NSString *historyIDE = @"historycell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:historyIDE];
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:historyIDE];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        LeRunModel *model = historyArray[indexPath.row];
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVW, 200)];
        [bgImageView sd_setImageWithURL:[NSURL URLWithString:model.posterImage] placeholderImage:[UIImage imageNamed:@"home.jpg"]];
        bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        bgImageView.clipsToBounds = YES;
        [cell.contentView addSubview:bgImageView];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 150, DEVW, 50)];
        view.backgroundColor = RGBA(205, 205, 205, 0.8);
        [cell.contentView addSubview:view];
        [FuncPublic InstanceSimpleLabel:model.leRunTitle Rect:CGRectMake(5, 10, DEVW, 20) addToView:view Font:[UIFont systemFontOfSize:20 weight:5] andTextColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] Aligment:0];
        [FuncPublic InstanceSimpleLabel:[NSString stringWithFormat:@"%@  %@",model.leRunTime,model.leRunAddress] Rect:CGRectMake(5, 30, DEVW, 20) addToView:view Font:[UIFont systemFontOfSize:14] andTextColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] Aligment:0];
        
        
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转到详情页面
    dispatch_async(dispatch_get_main_queue(), ^{
        LeRunModel *model = historyArray[indexPath.row];
        HistoryDetailViewController *hdVC = [HistoryDetailViewController new];
        hdVC.leRunID = model.leRunID;
        UIViewController *vc = [FuncPublic parentViewController:self.view];
        UIViewController *parentVC = [FuncPublic parentViewController:vc.view];
//        parentVC.hidesBottomBarWhenPushed = YES;
        [parentVC.navigationController pushViewController:hdVC animated:YES];
    });
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
