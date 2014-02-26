//
//  AddressToCoordinate.m
//  TaiwenIceCream
//
//  Created by David Tseng on 2/25/14.
//  Copyright (c) 2014 David Tseng. All rights reserved.
//

#import "AddressToCoordinate.h"

@implementation AddressToCoordinate

+(CLLocationCoordinate2D)locationFromAddress:(NSString*)address{

    NSString *requestStr = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false",address];
    NSString *requestStrEscaped = [requestStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:requestStrEscaped]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    CLLocationCoordinate2D loc;
    if (error == nil)
    {
        NSError * err;
        NSDictionary* responseObj = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:(kNilOptions) error:&err];
        
        NSArray *array = [responseObj objectForKey:@"results"];
        NSDictionary* contentDic;
        if (array.count>0) {
            contentDic = [array objectAtIndex:0];
        }
        NSDictionary* geometryDic = [contentDic objectForKey:@"geometry"];
        NSDictionary* locDic = [geometryDic objectForKey:@"location"];
        loc = CLLocationCoordinate2DMake([[locDic objectForKey:@"lat"] doubleValue], [[locDic objectForKey:@"lng"] doubleValue]);
    
    }else{
        
        NSLog(@"ERROR: %@",error);

    }
    
    return loc;
    
}


@end
