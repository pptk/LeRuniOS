//
//  DFAssetVC.h
//  GetImage
//
//  Created by ianc-ios on 15/9/19.
//  Copyright (c) 2015年 DeadFish7/25. All rights reserved.
//  find 照片

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface DFAssetVC : UITableViewController
{
    int selectedAssets;
    NSOperationQueue *queue;//线程
}
@property(assign,nonatomic)id parent;//

//ALAssetsGroup就是相册的累、可以通过valueForProperty方法查看不同的属性的值
//如：ALAssetsGroupPropertyName-- 相册名
@property(strong,nonatomic)ALAssetsGroup *assetGroup;

//@property(nonatomic)NSInteger ImageCount;

@property(strong,nonatomic)NSMutableArray *dfAssetsArray;
//创建一个数组。

-(int)totalSelectedAssets;
-(void)preparePhotos;
-(void)doneAction:(id)sender;

@end
