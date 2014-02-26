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

#define SEVEN_ELEVEN 0
#define FAMILY_MART 1
@interface ViewController () <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mpView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    self.mpView.delegate = self;
    [self.mpView setShowsUserLocation:YES];

    NSArray * iceCreamArray711 = [IceCreamReader arrayFrom711All];
    for (IceCreamSite * site in iceCreamArray711){
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:site.location];
        [annotation setTitle:@"7-11"];
        [annotation setSubtitle:site.name];
        [self.mpView addAnnotation:annotation];
    }
    
    NSArray * iceCreamArrayFamily = [IceCreamReader arrayFromFamilyMartAll];
    
    for (IceCreamSite * site in iceCreamArrayFamily){
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:site.location];
        [annotation setTitle:@"Family Mart"];
        [annotation setSubtitle:[NSString stringWithFormat:@"*%@",site.name]];
        [self.mpView addAnnotation:annotation];
    }
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {

    MKCoordinateRegion newRegion;
//    newRegion.center
    [self.mapView setRegion:self.mpView.userLocation. animated:NO];

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
    
    return annotationView;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
