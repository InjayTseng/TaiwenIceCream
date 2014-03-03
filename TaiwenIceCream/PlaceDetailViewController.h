//
//  VenueDetailViewController.h
//  FSQProject
//
//  Created by David Tseng on 2/11/14.
//  Copyright (c) 2014 David Tseng. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "IceCreamReader.h"


@interface PlaceDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet MKMapView *mpView;
@property IceCreamSite *currentSite;
@property (weak, nonatomic) IBOutlet UILabel *lbCategory;
@property (strong, nonatomic) IBOutlet UIButton *btnRoute;
@property (strong, nonatomic) IBOutlet UIButton *btnCall;
@property (strong, nonatomic) IBOutlet UIButton *btnOfficialSite;

- (IBAction)btnRouteToPlace:(id)sender;

@end
