//
//  ProviderSelectedViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/8/25.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "ProviderSelectedViewController.h"

@interface ProviderSelectedViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ProviderSelectedViewController
{
    NSArray *provinceArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"省份";
    self.providerTableView.delegate = self;
    self.providerTableView.dataSource = self;
    provinceArray = @[@"北京",@"天津",@"上海",@"江西",@"河北",@"山西",@"辽宁",@"吉林",@"黑龙江",@"江苏",@"浙江",@"安徽",@"福建",@"重庆",@"山东",@"河南",@"湖北",@"湖南",@"广东",@"海南",@"四川",@"贵州",@"云南",@"陕西",@"甘肃",@"青海",@"内蒙古",@"广西",@"西藏",@"宁夏",@"新疆",@"香港",@"澳门",@"台湾"];
}
#pragma mark delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return provinceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = provinceArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate selectedProvider:provinceArray[indexPath.row]];
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
