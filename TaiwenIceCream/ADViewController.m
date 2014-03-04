//
//  ViewController.m
//  Vpon-SDK
//
//  Created by vpon on 13/5/13.
//  Copyright (c) 2013年 com.vpon. All rights reserved.
//

#import "ADViewController.h"

@interface ADViewController ()

@end

@implementation ADViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    plat = TW;  // 台灣地區請填TW 大陸則填CN
    BOOL bStatusBarHide = [UIApplication sharedApplication].statusBarHidden;
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if(!bStatusBarHide)
        screenHeight -= 20;
    CGPoint origin = CGPointMake(0.0,screenHeight - CGSizeFromVponAdSize(VponAdSizeBanner).height);
//        CGPoint origin = CGPointMake(0.0,0.0);
    

    vponAd = [[VponBanner alloc] initWithAdSize:VponAdSizeBanner origin:origin];
    vponAd.strBannerId = @"8a808182447617bf01448858da90067b";   // 填入您的BannerId
    vponAd.delegate = self;
    vponAd.platform = TW;
    [vponAd setAdAutoRefresh:YES];
    [vponAd setRootViewController:self];
    [self.view addSubview:[vponAd getVponAdView]];
    [vponAd startGetAd:[self getTestIdentifiers]];
    
    // get Interstitial Ad
//    vponInterstitial = [[VponInterstitial alloc] init];
//    vponInterstitial.strBannerId = @"";   // 填入您的Interstitial BannerId
//    vponInterstitial.platform = TW;       // 台灣地區請填TW 大陸則填CN
//    vponInterstitial.delegate = self;
//    [vponInterstitial getInterstitial:[self getTestIdentifiers]];
}

// 請新增此function到您的程式內 如果為測試用 則在下方填入UUID
-(NSArray*)getTestIdentifiers
{
    return [NSArray arrayWithObjects:
            // add your test UUID
            nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark VponAdDelegate method 接一般Banner廣告就需要新增
- (void)onVponAdReceived:(UIView *)bannerView{
    NSLog(@"廣告抓取成功");
}

- (void)onVponAdFailed:(UIView *)bannerView didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"廣告抓取失敗");
}

- (void)onVponPresent:(UIView *)bannerView{
    NSLog(@"開啟vpon廣告頁面 %@",bannerView);
}

- (void)onVponDismiss:(UIView *)bannerView{
    NSLog(@"關閉vpon廣告頁面 %@",bannerView);
}

- (void)onVponLeaveApplication:(UIView *)bannerView{
    NSLog(@"離開publisher application");
}

#pragma mark VponInterstitial Delegate 有接Interstitial的廣告才需要新增
- (void)onVponInterstitialAdReceived:(UIView *)bannerView{
    NSLog(@"插屏廣告抓取成功");
    [vponInterstitial show];
}

- (void)onVponInterstitialAdFailed:(UIView *)bannerView{
    NSLog(@"插屏廣告抓取失敗");
}

- (void)onVponInterstitialAdDismiss:(UIView *)bannerView{
    NSLog(@"關閉插屏廣告頁面 %@",bannerView);
}

- (void)dealloc
{
    if(nil != vponInterstitial)
    {
        vponInterstitial = nil;
    }
    if(nil != vponAd)
    {
        vponAd = nil;
    }
}
@end
