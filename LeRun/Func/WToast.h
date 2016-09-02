//
//  WToast.h
//  MediaQRCode
//
//  Created by xiayp on 12-8-30.
//
//

#import <UIKit/UIKit.h>
#import "FuncPublic.h"

#define RGB(a, b, c) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:1.0f]
#define RGBA(a, b, c, d) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:d]

typedef enum {
	kWTShort = 2,
	kWTLong = 5
} WToastLength;

@interface WToast : UIView

+ (WToast *)showWithText:(NSString *)text;
//+ (void)showWithText:(NSString *)text;
+ (void)showWithImage:(UIImage *)image;

+ (WToast *)showWithText:(NSString *)text ToView:(WToast *)toast;

+ (void)showWithText:(NSString *)text length:(WToastLength)length;
+ (void)showWithImage:(UIImage *)image length:(WToastLength)length;


@end
