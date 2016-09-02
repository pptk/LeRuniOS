//
//  headerView.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/13.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureScrollView.h"
@interface headerView : UIView

@property (strong, nonatomic) IBOutlet PictureScrollView *pictureSV;

-(void)setHotActivity:(UIImage *)image1 image2:(UIImage *)image2;

@end
