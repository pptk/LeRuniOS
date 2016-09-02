//
//  DFAsset.h
//  GetImage
//
//  Created by ianc-ios on 15/9/19.
//  Copyright (c) 2015年 DeadFish7/25. All rights reserved.
//

#pragma mark 一张图片对象

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface DFAsset : UIView
{
    UIImageView *selectedView;//确认有没有选中的图片。
    BOOL selected;//创建一个BOOL值用来标示有无选中
}

@property(strong,nonatomic)ALAsset *asset;//通过ALAsset获得相应的资源
// ALAsset 可以获得图片的等比缩略图和原图等

//或者说ALAsset类代表相册中的每个资源文件、可以通过它获取资源文件的相关信息。并且可以修改和新建等
@property (assign,nonatomic)id parent;
-(id)initWithAsset:(ALAsset *)asset;
-(BOOL)selected;//选中方法
-(void)toggleSelection;//修改UIImageView的显示与否
@end
