//
//  Data.h
//  TaiwenIceCream
//
//  Created by David Tseng on 2/27/14.
//  Copyright (c) 2014 David Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^XBLOCK)();
typedef void(^INTBLOCK)(int x);

@interface Data : NSObject

+ (instancetype)sharedManager;
@property (nonatomic,readwrite) int sevenPopularity;
@property (nonatomic,readwrite) int familyPopularity;

+(NSString*)nextVoteTime;
+(void)fetchData;
+(void)fetchDataWithBlock:(XBLOCK)block;

+(BOOL)canVote;


@end
