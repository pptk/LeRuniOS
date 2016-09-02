//
//  MD5.m
//  xUtilsDemo
//
//  Created by 彭雄辉的Mac Pro on 16/5/8.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "NSString+MD5.h"


@implementation NSString(MD5)

-(NSString *)MD5{
    const char *ptr = [self UTF8String];//create pointer to the string as utf8
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];//create byte array of unsigned chars
    CC_MD5(ptr, strlen(ptr), md5Buffer);//create 16bytes MD5 hash value,store in buffer
    NSMutableString *outPut = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0;i<CC_MD5_DIGEST_LENGTH;i++)
        [outPut appendFormat:@"%02x",md5Buffer[i]];
    return outPut;
}

@end
