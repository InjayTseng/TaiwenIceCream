//
//  AddressToCoordinate.h
//  TaiwenIceCream
//
//  Created by David Tseng on 2/25/14.
//  Copyright (c) 2014 David Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AddressToCoordinate : NSObject

+(CLLocationCoordinate2D)locationFromAddress:(NSString*)address;


@end
