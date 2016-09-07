//
//  NumberWordLabel.m
//  QianLi
//
//  Created by ianc-ios on 15/12/11.
//  Copyright © 2015年 ianc. All rights reserved.
//

#import "NumberWordLabel.h"

@implementation NumberWordLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)setText:(NSString *)text withNumberSize:(CGFloat)numberSize withWordSize:(CGFloat)wordSize{
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:text];
    for(int i = 0;i<text.length;i++){
        NSString *str = [text substringWithRange:NSMakeRange(i, 1)];
        if([self isPureInt:str] || [str isEqualToString:@"-"]){
            NSRange numberRange = NSMakeRange(i, 1);
            [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:numberSize] range:numberRange];
        }else{
            [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:wordSize] range:NSMakeRange(i, 1)];
        }
    }
    [self setAttributedText:noteStr];
}

-(void)setText:(NSString *)text withNumberSize:(CGFloat)numberSize withWordSize:(CGFloat)wordSize withWordColor:(UIColor *)color{
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:text];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:wordSize],NSForegroundColorAttributeName:color};
    
    for(int i = 0;i<text.length;i++){
        NSString *str = [text substringWithRange:NSMakeRange(i, 1)];
        if([self isPureInt:str] || [str isEqualToString:@","] || [str isEqualToString:@"-"]){
            NSRange numberRange = NSMakeRange(i, 1);
            [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:numberSize] range:numberRange];
        }else{
            [noteStr addAttributes:dic range:NSMakeRange(i, 1)];
        }
    }
    [self setAttributedText:noteStr];
}

-(void)setText:(NSString *)text withNumberSize:(CGFloat)numberSize withWordSize:(CGFloat)wordSize withNumberColor:(UIColor *)color{
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:text];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:numberSize],NSForegroundColorAttributeName:color};
    
    for(int i = 0;i<text.length;i++){
        NSString *str = [text substringWithRange:NSMakeRange(i, 1)];
        if([self isPureInt:str] || [str isEqualToString:@"."] || [str isEqualToString:@","]){
            [noteStr addAttributes:dic range:NSMakeRange(i, 1)];
        }else{
            [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:wordSize] range:NSMakeRange(i, 1)];
        }
    }
    [self setAttributedText:noteStr];
}

-(BOOL)isPureInt:(NSString *)string{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
@end
