//
//  RunLeWebViewController.m
//  LeRun
//
//  Created by 彭雄辉的Mac Pro on 16/7/13.
//  Copyright © 2016年 彭雄辉的Mac Pro. All rights reserved.
//

#import "RunLeWebViewController.h"
#import "FuncPublic.h"
@interface RunLeWebViewController ()<UIWebViewDelegate>
{
    MBProgressHUD *hud;
}
@end

@implementation RunLeWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view from its nib.
    self.webView.delegate = self;
    if(self.title)
    {
        self.navigationController.title = self.title;
    }
    NSURL *url = [[NSURL alloc]initWithString:self.urlStr];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    self.webView.opaque = NO;
    [self.webView setBackgroundColor:[UIColor clearColor]];
    
//    [FuncPublic hideTabBar:self];
    hud = [FuncPublic ShowHUDWithLabel:(id<MBProgressHUDDelegate>)self Label:@"正在加载..."];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)webViewDidStartLoad:(UIWebView *)webView{

}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [FuncPublic HideHud:hud animating:YES];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
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
