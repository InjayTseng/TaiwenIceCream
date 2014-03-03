//
//  ViewController.m
//  TaiwenIceCream
//
//  Created by David Tseng on 2/25/14.
//  Copyright (c) 2014 David Tseng. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"
#import "AddressToCoordinate.h"
#import "IceCreamReader.h"
#import "PlaceDetailViewController.h"
#define SEVEN_ELEVEN 0
#define FAMILY_MART 1
#define TAG_BUTTON 9001

@interface ViewController () <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mpView;
@property (strong, nonatomic) NSMutableArray *siteArray;
@property (readwrite, nonatomic) BOOL isFirstTimeReload;



@end

@implementation ViewController

-(void)reloadMapWithDictionary:(NSNotification*)notif{

    NSDictionary* dic = notif.object;
    
    NSLog(@"%@",dic);
    
    [self.mpView removeAnnotations:self.mpView.annotations];
    if ([dic[@"711isShowOnMap"] boolValue]) {
        [self add711ToMap];
    }
    
    if ([dic[@"FamilyisShowOnMap"] boolValue]) {
        [self addFamilyToMap];
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.siteArray = [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMapWithDictionary:) name:@"ReloadMapWithDictionary" object:nil];
    
    self.navigationItem.title = @"冰淇淋在哪裡";
    self.isFirstTimeReload = NO;
    self.mpView.delegate = self;
    [self.mpView setShowsUserLocation:YES];

    [self add711ToMap];
    [self addFamilyToMap];
}

-(void)add711ToMap{
    NSArray * iceCreamArray711 = [IceCreamReader arrayFrom711All];
    for (IceCreamSite * site in iceCreamArray711){
        site.type = @"7-11";
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:site.location];
        [annotation setTitle:@"7-11"];
        [annotation setSubtitle:site.name];
        [self.mpView addAnnotation:annotation];
    }
    [self.siteArray addObjectsFromArray:iceCreamArray711];
}


-(void)addFamilyToMap{
    NSArray * iceCreamArrayFamily = [IceCreamReader arrayFromFamilyMartAll];
    for (IceCreamSite * site in iceCreamArrayFamily){
        site.type = @"Family Mart";
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:site.location];
        [annotation setTitle:@"Family Mart"];
        [annotation setSubtitle:[NSString stringWithFormat:@"%@",site.name]];
        [self.mpView addAnnotation:annotation];
    }
    [self.siteArray addObjectsFromArray:iceCreamArrayFamily];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {

    
    if (!self.isFirstTimeReload) {
        self.isFirstTimeReload= YES;
        MKCoordinateRegion newRegion;
        newRegion.center = self.mpView.userLocation.coordinate;
        newRegion.span.latitudeDelta = 0.1;
        newRegion.span.longitudeDelta = 0.1;
        
        [self.mpView setRegion:newRegion animated:YES];
    }

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{

    if (annotation == mapView.userLocation) {
        
        return nil;
    }
    
    static NSString *viewId1 = @"MKPinAnnotationView";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)
    [self.mpView dequeueReusableAnnotationViewWithIdentifier:viewId1];
    
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc]
                          initWithAnnotation:annotation reuseIdentifier:viewId1];
        annotationView.canShowCallout = YES;
    }
    
    if ([[annotation title] isEqualToString:@"7-11"]) {
        
        [annotationView setPinColor:MKPinAnnotationColorRed];
        
    }else{
        
        [annotationView setPinColor:MKPinAnnotationColorGreen];
    }
    
    UIButton*myButton =[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    myButton.frame =CGRectMake(0,0,40,40);
    [myButton addTarget:self action:@selector(annotaionViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    [myButton setRestorationIdentifier:[annotation subtitle]];
    [myButton setTag:TAG_BUTTON];
    annotationView.rightCalloutAccessoryView = myButton;
    
    return annotationView;

}


-(void)annotaionViewClicked:(id)sender{
    
    UIButton *btn = sender;
    //    NSLog(@"sender %@",btn.restorationIdentifier);
    IceCreamSite *site = [self searchSiteByTitle:btn.restorationIdentifier];
    //[self navigatesToDetailbySite:site];
    NSLog(@"Go to %@",site.name);
    
    if (site) {
        
        PlaceDetailViewController *dv = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceDetailViewController"];
        [dv setCurrentSite:site];
        [self.navigationController pushViewController:dv animated:YES];
        
    }else{
    
        [SVProgressHUD showErrorWithStatus:@"無法開啟"];
        
    }
    
}

-(IceCreamSite*)searchSiteByTitle:(NSString*)name{

    for (IceCreamSite* site in self.siteArray){
        if ([site.name isEqualToString:name]) {
            
            return site;
        }
    }

    return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
