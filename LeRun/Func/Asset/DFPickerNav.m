//
//  DFPickerNav.m
//  GetImage
//
//  Created by ianc-ios on 15/9/19.
//  Copyright (c) 2015年 DeadFish7/25. All rights reserved.
//

#import "DFPickerNav.h"

@interface DFPickerNav ()

@end

@implementation DFPickerNav
@synthesize Mydelegate = Mydelegate;
- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark 将选中的图片找到、存入字典、并且使用代理、传给实现代理的方法
-(void)selectedAssets:(NSArray *)_assets{
    NSMutableArray *returnArray = [[NSMutableArray alloc]init];
    for(ALAsset *asset in _assets){
        NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc]init];
        [workingDictionary setObject:[asset valueForProperty:ALAssetPropertyType] forKey:@"UIImagePickerControllerMediaType"];
        [workingDictionary setObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]] forKey:@"UIImagePickerControllerMediaType"];
        [workingDictionary setObject:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys]objectAtIndex:0]] forKey:@"UIImagePickerControllerReferenceURL"];
        [returnArray addObject:workingDictionary];
    }
    //判断是否有以dfpickernav:didfinishPickingMediaWithInfo命名的方法
    if([Mydelegate respondsToSelector:@selector(dfPickerNav:didFinishPickingMediaWithInfo:)]){
        //如果有的话、代理将这个returnArray传过去。执行。
        [Mydelegate dfPickerNav:self didFinishPickingMediaWithInfo:[NSArray arrayWithArray:returnArray]];
    }
}
#pragma mark 取消按钮、隐藏掉ImagePicker
-(void)cancelImagePicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
