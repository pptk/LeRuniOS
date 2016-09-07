//
//  HistoryHeader.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/8/9.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "HistoryHeader.h"
#import "UIImageView+WebCache.h"
@implementation HistoryHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
        NSArray *views = [[NSBundle mainBundle]loadNibNamed:@"HistoryHeader" owner:nil options:nil];
        self = views[0];
        [FuncPublic InstanceSimpleView:CGRectMake(0, 282.5, CGRectGetWidth(self.frame), 0.5) backgroundColor:RGB(205, 205, 205) addToView:self];
        self.historyContent.scrollsToTop = YES;
    }
    return self;
}
-(void)setModel:(LeRunModel *)model{
    [self.postImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.posterImage]] placeholderImage:[UIImage imageNamed:@"home.jpg"]];
    NSInteger k = [model.score intValue];//分数
    for(int i = 0;i<k;i++){
        NSString *proStr = [NSString stringWithFormat:@"startImageView%d",i+1];
//        [self setValue:[UIImage imageNamed:@"comment_score_yes.png"] forKey:proStr];
        UIImageView *imageView = [self valueForKey:proStr];
        imageView.image = [UIImage imageNamed:@"comment_score_yes.png"];
    }
    self.scoreLabel.text = model.score;
    self.historyTitleLabel.text = model.leRunTitle;
    self.historyTimeLabel.text = model.leRunTime;
    self.historyContent.text = model.leRunContent;
    self.hostLabel.text = [NSString stringWithFormat:@"承办方:%@",model.leRunHost];
    self.takePartIn.text = [NSString stringWithFormat:@"参与人数:%@",model.leRunMaxUser];
    [self setNeedsLayout];
}

@end
