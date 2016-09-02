//
//  DFAssetVC.m
//  GetImage
//
//  Created by ianc-ios on 15/9/19.
//  Copyright (c) 2015年 DeadFish7/25. All rights reserved.
//

#import "DFAssetVC.h"
#import "DFAsset.h"
#import "DFAssetCell.h"
#import "DFPickerVC.h"

@interface DFAssetVC ()
{
    DFAsset *dfAsset;
    NSMutableArray *selectedArray;//选中图片的数组
}
@end

@implementation DFAssetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    self.dfAssetsArray = [[NSMutableArray alloc]init];//所有图片的数组
    selectedArray = [[NSMutableArray alloc]init];
}
-(void)createUI{
    self.title = @"照片";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //UIBarButtonItem right
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction:)];
    [self.navigationItem setRightBarButtonItem:doneButtonItem];
    //查找图片
    [self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
}
#pragma mark 获取照片、展示
-(void)preparePhotos{
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        //如果没有照片。那么直接返回
        if(result == nil){
            return;
        }
        dfAsset = [[DFAsset alloc]initWithAsset:result];
        //添加点击事件。注意。initWithTarget原本使用dfAsset来实现。我修改成self方便管理数组
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [dfAsset addGestureRecognizer:tap];
        
        dfAsset.parent = self;//设置代理
        [self.dfAssetsArray addObject:dfAsset];//将数据加载到数组中去。
    }];
    dispatch_async(dispatch_get_main_queue(),^{
        [self.tableView reloadData];//重新加载UITableView。因为dfAssetArray是数据源
        self.title = @"照片";
    });
}
#pragma mark 点击方法
-(void)tapAction:(UITapGestureRecognizer *)tap{
    DFAsset *selectedAsset = (DFAsset *)tap.view;
    if(selectedAsset.selected == NO){//如果不是选中状态
        NSLog(@"------------is true");
        if(selectedArray.count < 3){
            [selectedAsset toggleSelection];//修改UIImage的selectedImageView状态
            [selectedArray addObject:[selectedAsset asset]];//将asset加入到selectedArray中
        }else{
            //        NSLog(@"最多只能选中x张图片");
//            [self.view makeToast:[NSString stringWithFormat:@"现在最多只能选择%ld张图片哦",self.ImageCount] duration:0.5 position:CSToastPositionCenter];
            NSLog(@"最多只能选择三章图片哦。");
        }
    }else{
        NSLog(@"------------is false");
        //当前这个图片对象
        //        [selectedAsset asset];
        ALAsset *removeThis;
        for (ALAsset *asset in selectedArray) {
            if (asset == [selectedAsset asset]) {
                removeThis = asset;//枚举里面不能直接remove掉object。否则程序崩溃。
            }
        }
        [selectedArray removeObject:removeThis];
        [selectedAsset toggleSelection];
    }
}


#pragma mark 点击完成按钮
-(void)doneAction:(id)sender{
    NSLog(@"YES1");
    [(DFPickerVC *)self.parent selectedAssets:selectedArray];//将选中的数组send给调用页面。
    [self dismissViewControllerAnimated:YES completion:nil];//关闭。
}
#pragma mark 表格式图的各种代理
-(NSArray *)assetsForIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = (indexPath.row * 4);
    NSInteger maxIndex = (indexPath.row * 4 + 3);
    if(maxIndex < [self.dfAssetsArray count]){
        return [NSArray arrayWithObjects:[self.dfAssetsArray objectAtIndex:index],
                                   [self.dfAssetsArray objectAtIndex:index+1],
                [self.dfAssetsArray objectAtIndex:index+2],
                [self.dfAssetsArray objectAtIndex:index+3],nil];
    }else if(maxIndex -1 < [self.dfAssetsArray count]){
        return [NSArray arrayWithObjects:[self.dfAssetsArray objectAtIndex:index],
                [self.dfAssetsArray objectAtIndex:index+1],
                [self.dfAssetsArray objectAtIndex:index+2],
                nil];
    }
    else if (maxIndex - 2 < [self.dfAssetsArray count]) {
        
        return [NSArray arrayWithObjects:[self.dfAssetsArray objectAtIndex:index],
                [self.dfAssetsArray objectAtIndex:index+1],
                nil];
    }
    else if(maxIndex - 3 < [self.dfAssetsArray count]) {
        return [NSArray arrayWithObject:[self.dfAssetsArray objectAtIndex:index]];
    }
    return nil;
}
#pragma mark 各种代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ([self.assetGroup numberOfAssets] +3 )/4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80*[self ratio];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"Cell";
    DFAssetCell *cell = (DFAssetCell *)[tableView dequeueReusableCellWithIdentifier:Identifier];
    if(cell == nil){
        cell = [[DFAssetCell alloc]initWithAssets:[self assetsForIndexPath:indexPath] reuseIdentifier:Identifier];
    }else{
        [cell setAssets:[self assetsForIndexPath:indexPath]];
    }
    return cell;
}
-(int)totalSelectedAssets{
    int count = 0;
    for(DFAsset *asset in self.dfAssetsArray){
        if([asset selected]){
            count ++;
        }
    }
    return count;
}

-(CGFloat)ratio{
    return [UIScreen mainScreen].bounds.size.width/320;
}

@end
