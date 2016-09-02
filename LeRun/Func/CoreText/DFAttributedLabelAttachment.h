//
//  DFAttributedLabelAttachment.h
//  DFAttributedLabel
//
//  Created by ianc-ios on 15/11/11.
//  Copyright (c) 2015年 彭雄辉10/9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFAttributedLabelDefines.h"
#import <UIKit/UIKit.h>

void deallocCallback(void* ref);
CGFloat ascentCallback(void *ref);
CGFloat descentCallback(void *ref);
CGFloat widthCallback(void* ref);

@interface DFAttributedLabelAttachment : NSObject
@property (nonatomic,strong)    id                  content;
@property (nonatomic,assign)    UIEdgeInsets        margin;
@property (nonatomic,assign)    DFImageAlignment   alignment;
@property (nonatomic,assign)    CGFloat             fontAscent;
@property (nonatomic,assign)    CGFloat             fontDescent;
@property (nonatomic,assign)    CGSize              maxSize;


+ (DFAttributedLabelAttachment *)attachmentWith: (id)content
                                          margin: (UIEdgeInsets)margin
                                       alignment: (DFImageAlignment)alignment
                                         maxSize: (CGSize)maxSize;

- (CGSize)boxSize;

@end
