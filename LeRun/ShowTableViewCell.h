//
//  ShowTableViewCell.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/18.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *loveCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (strong, nonatomic) IBOutlet UIButton *loveBtn;
//@property (strong, nonatomic) IBOutlet UIImageView *contentImageView1;
//@property (strong, nonatomic) IBOutlet UIImageView *contentImageView2;
//@property (strong, nonatomic) IBOutlet UIImageView *contentImageView3;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionCell;
@property(nonatomic,strong)NSMutableArray *imageArray;

@property (strong, nonatomic) IBOutlet UIImageView *shareBtn;


@end
