//
//  DFAssetCell.h
//  GetImage
//
//  Created by ianc-ios on 15/9/19.
//  Copyright (c) 2015年 DeadFish7/25. All rights reserved.
//

#define topMargin 5

#import <UIKit/UIKit.h>

@interface DFAssetCell : UITableViewCell
//单元格的创建方法
-(instancetype)initWithAssets:(NSArray *)assets reuseIdentifier:(NSString *)identifier;
//传入这个Assets的方法
-(void)setAssets:(NSArray *)assets;

@property(nonatomic,retain)NSArray *linesAssets;//传入图片的数组。应该是所有的图片
@end
