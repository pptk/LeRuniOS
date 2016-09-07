//
//  NumberWordLabel.h
//  QianLi
//
//  Created by ianc-ios on 15/12/11.
//  Copyright © 2015年 ianc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberWordLabel : UILabel

-(void)setText:(NSString *)text withNumberSize:(CGFloat)numberSize withWordSize:(CGFloat)wordSize withWordColor:(UIColor *)color;
-(void)setText:(NSString *)text withNumberSize:(CGFloat)numberSize withWordSize:(CGFloat)wordSize withNumberColor:(UIColor *)color;
-(void)setText:(NSString *)text withNumberSize:(CGFloat)numberSize withWordSize:(CGFloat)wordSize;


@end
