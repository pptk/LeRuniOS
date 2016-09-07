//
//  ShowTableViewCell.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/18.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "ShowTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "GBAvatarBrowser.h"
#import <ShareSDK/ShareSDK.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#define identifier @"imagecell"
@implementation ShowTableViewCell
- (void)awakeFromNib {
    self.collectionCell.dataSource = self;
    self.collectionCell.delegate = self;
    [self.collectionCell registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    if(self.imageArray){
        self.imageArray = [NSMutableArray array];
    }
}


-(void)setImageArray:(NSMutableArray *)imageArray{
    _imageArray = imageArray;
    [self.collectionCell reloadData];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    GBAvatarBrowser *imageView = [[GBAvatarBrowser alloc]initWithFrame:CGRectMake(0, 0, 70, 80)];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor whiteColor];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"home.jpg"]];
    [cell addSubview:imageView];
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
