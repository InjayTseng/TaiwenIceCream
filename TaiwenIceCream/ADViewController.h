//
//  ViewController.h
//  Vpon-SDK
//
//  Created by vpon on 13/5/13.
//  Copyright (c) 2013年 com.vpon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VponBanner.h"
#import "VponInterstitial.h"

@interface ADViewController : UIViewController<VponBannerDelegate, VponInterstitialDelegate>
{
    VponBanner*         vponAd;
    VponInterstitial*   vponInterstitial;
    Platform            plat;
}
@end
