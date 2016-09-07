//
//  MainTableViewCell.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/5.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headerImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;

@property (strong, nonatomic) IBOutlet UILabel *seeLabel;//浏览量
@property (strong, nonatomic) IBOutlet UILabel *loveLabel;//点赞文本
@property (strong, nonatomic) IBOutlet UIButton *loveBtn;//点赞按钮



@end
