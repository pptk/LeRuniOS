//
//  DFPickerNav.h
//  GetImage
//
//  Created by ianc-ios on 15/9/19.
//  Copyright (c) 2015年 DeadFish7/25. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class DFPickerNav;

@protocol DFPickerDelegate <NSObject>
-(void)dfPickerNav:(DFPickerNav *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
-(void)dfPickerNavDidCancel:(DFPickerNav *)picker;
@end

@interface DFPickerNav : UINavigationController

@property(assign,nonatomic)id<DFPickerDelegate>Mydelegate;

-(void)selectedAssets:(NSArray *)_assets;
-(void)cancelImagePicker;
@end
