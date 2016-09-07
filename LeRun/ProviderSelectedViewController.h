//
//  ProviderSelectedViewController.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/8/25.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProviderDelegate <NSObject>
-(void)selectedProvider:(NSString *)provider;//回调方法
@end

@interface ProviderSelectedViewController : UIViewController

@property(nonatomic,retain)id<ProviderDelegate> delegate;//选择城市回调方法
@property (strong, nonatomic) IBOutlet UITableView *providerTableView;

@end
