//
//  VenueDetailViewController.m
//  FSQProject
//
//  Created by David Tseng on 2/11/14.
//  Copyright (c) 2014 David Tseng. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PlaceDetailViewController.h"
#import "SVProgressHUD.h"
#import "NewsWebPageViewController.h"

@interface PlaceDetailViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation PlaceDetailViewController

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

    if (!self.currentSite.phone) {
        self.btnCall.alpha = 0.3;
        self.btnCall.enabled = FALSE;

    }else{
        
        NSString *callshow = [NSString stringWithFormat:@"打給 %@",self.currentSite.phone];
        [self.btnCall setTitle:callshow forState:UIControlStateNormal];
        
    }
    self.navigationItem.title = self.currentSite.name;
    self.lbCategory.text = self.currentSite.type;

    [self.imgView setFrame:CGRectMake(0, 0, 320, 700)];
    [self mapSetting];
    [self buttonDisplay];
}



-(void)buttonDisplay{

    [self setButtonShadow:self.btnRoute];
    [self setButtonShadow:self.btnCall];
    [self setButtonShadow:self.btnOfficialSite];
}


-(void)setButtonShadow:(UIButton*)btn{
    
    btn.layer.cornerRadius = 8.0f;
    btn.layer.masksToBounds = NO;
    btn.layer.borderWidth = 0.0f;
    
    btn.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    btn.layer.shadowOpacity = 0.8;
    btn.layer.shadowRadius = 8;
    btn.layer.shadowOffset = CGSizeMake(8.0f, 8.0f);


}

-(void)mapSetting{
    
    self.mpView.layer.cornerRadius = 10.0;
    
    MKCoordinateRegion newRegion;
    newRegion.center = self.currentSite.location;
    newRegion.span.latitudeDelta=0.01;
    newRegion.span.longitudeDelta=0.01;
    
    [self.mpView setRegion:newRegion animated:NO];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:self.currentSite.location];
    [annotation setTitle:self.currentSite.name];
    [self.mpView removeAnnotations:self.mpView.annotations];
    [self.mpView addAnnotation:annotation];
    [self.mpView setShowsUserLocation:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnRouteToPlace:(id)sender {
    
    [self routeFrom:self.mpView.userLocation.location.coordinate.latitude andLon:self.mpView.userLocation.location.coordinate.longitude  toLocation:self.currentSite.location.latitude andLon:self.currentSite.location.longitude];
    
}

- (IBAction)btnCall:(id)sender {

    NSString *callStr = [NSString stringWithFormat:@"tel:%@",self.currentSite.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr]];

}

-(IBAction)btnGoOfficialIntro:(id)sender {
    
    if ([self.currentSite.type isEqualToString:@"7-11"]) {

        NewsWebPageViewController* nv = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsWebPageViewController"];
        [nv setUrl:@"http://www.7-11.com.tw/event1/13icecream/index.html"];
            ;
        [self.navigationController pushViewController:nv animated:YES];
    }else{
        
        NewsWebPageViewController* nv = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsWebPageViewController"];
        [nv setUrl:@"http://www.family.com.tw/Marketing/food/ice_cream.html"];
        [self.navigationController pushViewController:nv animated:YES];

    }
}


-(void)routeFrom:(double)lat1 andLon:(double)lon1 toLocation:(double)lat2 andLon:(double)lon2{
    
    CLLocationCoordinate2D location1;
    location1.latitude = lat1;
    location1.longitude = lon1;
    
    CLLocationCoordinate2D location2;
    location2.latitude = lat2;
    location2.longitude = lon2;
    
    MKPlacemark *annotation1 = [[MKPlacemark alloc]initWithCoordinate:location1 addressDictionary:nil];
    MKMapItem *curItem = [[MKMapItem alloc]initWithPlacemark:annotation1];
    
    MKPlacemark *annotation2 = [[MKPlacemark alloc]initWithCoordinate:location2 addressDictionary:nil];
    MKMapItem *toItem = [[MKMapItem alloc]initWithPlacemark:annotation2];
    
    NSArray *array = [[NSArray alloc] initWithObjects:curItem,toItem,nil];
    NSDictionary *dicOption = @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking,
                                MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES] };
    [MKMapItem openMapsWithItems:array launchOptions:dicOption];
}



@end
