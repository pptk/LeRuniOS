//
//  RunLeWebViewController.h
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/13.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunLeWebViewController : BaseViewController

@property(nonatomic,copy)NSString *urlStr;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,copy)NSString *title;
@end
