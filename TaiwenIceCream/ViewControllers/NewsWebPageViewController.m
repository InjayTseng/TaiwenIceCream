//
//  NewsWebPageViewController.m
//  test
//
//  Created by David Tseng on 2/8/14.
//  Copyright (c) 2014 David Tseng. All rights reserved.
//

#import "NewsWebPageViewController.h"

@interface NewsWebPageViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *wbView;

@end

@implementation NewsWebPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        //        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.000 green:0.251 blue:0.502 alpha:1.000]];
    } else {
        
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
    self.navigationItem.title = self.showTitle;
    NSURL*url=[NSURL URLWithString:self.url];
    NSURLRequest*request=[NSURLRequest requestWithURL:url];
    self.wbView.delegate = self;
    [self.wbView loadRequest:request];
    [SVProgressHUD showWithStatus:@"讀取中"];
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{

    [SVProgressHUD dismiss];
//    NSString *jsCommand = [NSString stringWithFormat:@"document.body.style.zoom = 2.5;"];
//    [self.wbView stringByEvaluatingJavaScriptFromString:jsCommand];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
