//
//  DFPickerVC.m
//  GetImage
//
//  Created by ianc-ios on 15/9/19.
//  Copyright (c) 2015年 DeadFish7/25. All rights reserved.
//

#import "DFPickerVC.h"
#import "DFPickerNav.h"
#import "DFAssetVC.h"
@interface DFPickerVC ()

@end

@implementation DFPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    //初始化
    self.assetGroups = [NSMutableArray array];//数据源数组初始化
    library = [[ALAssetsLibrary alloc]init];//ALAssetsLibrary初始化
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //查找相册
        void(^assetGroupEnumerator)(ALAssetsGroup *,BOOL *) = ^(ALAssetsGroup *group,BOOL *stop){
            //如果没有。直接return
            if(group == nil){
                return;
            }
            //如果有就加到assetGroups里面去。并且刷新。
            [self.assetGroups addObject:group];
            [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
        };
        void(^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ERROR" message:[NSString stringWithFormat:@"Error:%@-%@",[error localizedDescription],[error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            NSLog(@"A Problem occured %@",[error description]);
        };
       [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetGroupEnumerator failureBlock:assetGroupEnumberatorFailure];
    });
    
}
#pragma mark new视图
-(void)createUI{
    self.title = @"相册";
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelImagePicker)];
    [self.navigationItem setRightBarButtonItem:cancelButton];
}
#pragma mark 取消按钮
-(void)cancelImagePicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 刷新tableView
-(void)reloadTableView{
    [self.tableView reloadData];
}
-(void)selectedAssets:(NSArray *)_assets{
    [(DFPickerNav *)self.parent selectedAssets:_assets];
}
#pragma mark 表格视图的各种代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.assetGroups count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //获取相册图标
    ALAssetsGroup *g = (ALAssetsGroup *)[self.assetGroups objectAtIndex:indexPath.row];
    [g setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger gCount = [g numberOfAssets];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",[g valueForProperty:ALAssetsGroupPropertyName],(long)gCount];
    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup *)[self.assetGroups objectAtIndex:indexPath.row] posterImage]]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DFAssetVC *VC = [DFAssetVC new];
//    VC.ImageCount = self.ImageCount;
    VC.parent = self;
    VC.assetGroup = [self.assetGroups objectAtIndex:indexPath.row];
    [VC.assetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    [self.navigationController pushViewController:VC animated:YES];
}
@end
