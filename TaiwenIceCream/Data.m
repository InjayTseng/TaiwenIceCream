//
//  Data.m
//  TaiwenIceCream
//
//  Created by David Tseng on 2/27/14.
//  Copyright (c) 2014 David Tseng. All rights reserved.
//

#import "Data.h"
#import "NSDate+Calculations.h"
#import <Parse/Parse.h>
#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject;


@implementation Data

+ (instancetype)sharedManager{
	DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
		return [[self alloc] init];
	});
}

- (id)init	{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(void)fetchData{


    [self getPopularityByName:@"7-11" andComplete:^(int x) {
    
        [[Data sharedManager] setSevenPopularity:x];
        NSLog(@"Got %d from 7-11.",x);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishedFetchingData" object:nil ];
    }];
    
    [self getPopularityByName:@"FamilyMart" andComplete:^(int x) {
        
        [[Data sharedManager] setFamilyPopularity:x];
        NSLog(@"Got %d from FamilyMart",x);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishedFetchingData" object:nil ];
    }];
    

}

+(BOOL)canVote{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *voteDate = [defaults objectForKey:@"VoteDate"];
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
//    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
//    NSString *stringFromDate = [formatter stringFromDate:voteDate];
//    NSString *stringFromNow = [formatter stringFromDate:[NSDate date]];
//    NSLog(@"現在%@ 可以在投:%@",stringFromNow,stringFromDate);

    
    if (voteDate == nil) {
        return TRUE;
    }
    if ([voteDate past]) {

        return TRUE;
    }

    return FALSE;
}

+(NSString*)nextVoteTime{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *voteDate = [defaults objectForKey:@"VoteDate"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *stringFromDate = [formatter stringFromDate:voteDate];
    NSString *stringFromNow = [formatter stringFromDate:[NSDate date]];
    NSLog(@"現在%@ 可以在投:%@",stringFromNow,stringFromDate);


    return stringFromDate;
}

+(void)getPopularityByName:(NSString*)name andComplete:(INTBLOCK)intBlock{
    
    PFQuery *query = [PFQuery queryWithClassName:@"IceCreamShops"];
    [query whereKey:@"name" equalTo:name];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        for (PFObject *object in objects) {
            
            NSNumber* popularity_count = [object objectForKey:@"popularity"];
            intBlock([popularity_count intValue]);

        }
    }];
}


@end
