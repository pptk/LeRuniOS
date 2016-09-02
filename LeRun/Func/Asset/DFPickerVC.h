//
//  DFPickerVC.h
//  GetImage
//
//  Created by ianc-ios on 15/9/19.
//  Copyright (c) 2015年 DeadFish7/25. All rights reserved.
//  find 相册

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface DFPickerVC : UITableViewController
{
    NSOperationQueue *queue;//开辟线程
    ALAssetsLibrary *library;//ALAssetsLibrary类可以实现查看相册列表，增加相册。保存图片到相册的功能
}
//@property(nonatomic)NSInteger ImageCount;
@property(assign,nonatomic)id parent;
@property(strong,nonatomic)NSMutableArray *assetGroups;//装相册的数组。
-(void)selectedAssets:(NSArray *)assets;
@end
