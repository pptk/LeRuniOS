//
//  DFAttributedLabelURL.h
//  DFAttributedLabel
//
//  Created by ianc-ios on 15/11/11.
//  Copyright (c) 2015年 彭雄辉10/9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFAttributedLabelDefines.h"
#import <UIKit/UIKit.h>

@interface DFAttributedLabelURL : NSObject
@property (nonatomic,strong)    id      linkData;
@property (nonatomic,assign)    NSRange range;
@property (nonatomic,strong)    UIColor *color;

+ (DFAttributedLabelURL *)urlWithLinkData: (id)linkData
                                     range: (NSRange)range
                                     color: (UIColor *)color;


+ (NSArray *)detectLinks: (NSString *)plainText;

+ (void)setCustomDetectMethod:(DFCustomDetectLinkBlock)block;
@end


