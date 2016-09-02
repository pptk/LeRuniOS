//
//  DFAttributedLabelDefines.h
//  DFAttributedLabel
//
//  Created by ianc-ios on 15/11/11.
//  Copyright (c) 2015年 彭雄辉10/9. All rights reserved.
//

#ifndef DFAttributedLabel_DFAttributedLabelDefines_h
#define DFAttributedLabel_DFAttributedLabelDefines_h

typedef enum
{
    DFImageAlignmentTop,
    DFImageAlignmentCenter,
    DFImageAlignmentBottom
} DFImageAlignment;

@class DFAttributedLabel;

@protocol DFAttributedLabelDelegate <NSObject>
- (void)dfAttributedLabel:(DFAttributedLabel *)label
             clickedOnLink:(id)linkData;

@end

typedef NSArray *(^DFCustomDetectLinkBlock)(NSString *text);

//如果文本长度小于这个值,直接在UI线程做Link检测,否则都dispatch到共享线程
#define DFMinAsyncDetectLinkLength 50

#define DFIOS7 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)

#endif
