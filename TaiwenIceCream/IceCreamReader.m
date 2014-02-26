//
//  IceCreamReader.m
//  TaiwenIceCream
//
//  Created by David Tseng on 2/26/14.
//  Copyright (c) 2014 David Tseng. All rights reserved.
//

#import "IceCreamReader.h"

@implementation IceCreamReader


+(NSDictionary*)supportingDictionary{

    static NSDictionary *dic;
    dic                      = @{@"基隆市": @"1",
                                 @"台北市": @"2",
                                 @"新北市": @"3",
                                 @"桃園市": @"4",
                                 @"新竹縣": @"5",
                                 @"新竹市": @"6",
                                 @"苗栗縣": @"7",
                                 @"台中市": @"8",
                                 @"彰化縣": @"9",
                                 @"雲林縣": @"10",
                                 @"南投縣": @"11",
                                 @"嘉義縣": @"12",
                                 @"嘉義市": @"13",
                                 @"台南市": @"14",
                                 @"高雄市": @"15",
                                 @"屏東縣": @"16",
                                 @"宜蘭縣": @"17",
                                 @"花蓮縣": @"18",
                                 @"台東縣": @"19",
                                 @"澎湖": @"20",
                                 @"金門": @"21",
                                 @"馬祖": @"22"}
    ;
    return dic;
}

+(NSArray*)arrayFromFamilyMartAll{

    NSMutableArray * temparray = [[NSMutableArray alloc]init];

    for (int i=1;i<=22;i++){
        NSString* fileName = [NSString stringWithFormat:@"family-ice-%02d",i];
        NSArray* array = [self dictionaryArrayFromJsonArray:[self readFromFileName:fileName] withLog:YES];
        NSMutableArray* tempArray = [[NSMutableArray alloc]init];
        for (NSDictionary* dic in array){
            IceCreamSite *site = [[IceCreamSite alloc]initFromDictionary:dic];
            [tempArray addObject:site];
        }
        NSArray *siteArray = [NSArray arrayWithArray:tempArray];
        [temparray addObjectsFromArray:siteArray];
    }

    NSArray* resultArray = [NSArray arrayWithArray:temparray];
    return resultArray;
}

+(NSArray*)arrayFrom711All{
    NSMutableArray * temparray = [[NSMutableArray alloc]init];
    
    for (int i=1;i<=22;i++){
        NSString* fileName = [NSString stringWithFormat:@"711-icecream-%02d",i];
        NSArray* array = [self dictionaryArrayFromJsonArray:[self readFromFileName:fileName] withLog:YES];
        NSMutableArray* tempArray = [[NSMutableArray alloc]init];
        for (NSDictionary* dic in array){
            IceCreamSite *site = [[IceCreamSite alloc]initFromDictionary:dic];
            [tempArray addObject:site];
        }
        NSArray *siteArray = [NSArray arrayWithArray:tempArray];
        [temparray addObjectsFromArray:siteArray];
    }
    
    NSArray* resultArray = [NSArray arrayWithArray:temparray];
    return resultArray;
}

+(NSArray*)arrayFromFamilyMartWithPlaceName:(NSString*)place{

    int numberOfCity = [self enumOfPlace:place];
    NSString* fileName = [NSString stringWithFormat:@"family-ice-%02d",numberOfCity];
    NSArray* array = [self dictionaryArrayFromJsonArray:[self readFromFileName:fileName] withLog:YES];
    NSMutableArray* tempArray = [[NSMutableArray alloc]init];
    for (NSDictionary* dic in array){
        IceCreamSite *site = [[IceCreamSite alloc]initFromDictionary:dic];
        [tempArray addObject:site];
    }
    NSArray * resultArray = [NSArray arrayWithArray:tempArray];
    return resultArray;
    
}

+(NSArray*)arrayFrom711WithPlaceName:(NSString*)place{

    int numberOfCity = [self enumOfPlace:place];
    NSString* fileName = [NSString stringWithFormat:@"711-icecream-%02d",numberOfCity];
    NSArray* array = [self dictionaryArrayFromJsonArray:[self readFromFileName:fileName] withLog:YES];
    NSMutableArray* tempArray = [[NSMutableArray alloc]init];
    for (NSDictionary* dic in array){
        IceCreamSite *site = [[IceCreamSite alloc]initFromDictionary:dic];
        [tempArray addObject:site];
    }
    NSArray * resultArray = [NSArray arrayWithArray:tempArray];
    return resultArray;
}



#pragma mark - Basics
+(int)enumOfPlace:(NSString*)place{
    
    NSDictionary* dic = [self supportingDictionary];
    
    if ([dic objectForKey:place]) {
        
        return [[dic objectForKey:place] intValue];
        
    }else{
        
        return 0;
    }
    return 0;
}


+(NSString*)readFromFileName:(NSString*)fileName{

    NSString* fileRoot = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:fileRoot
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    return content;
}

+(NSArray*)dictionaryArrayFromJsonArray:(NSString*)jsonString{

    return [self dictionaryArrayFromJsonArray:jsonString withLog:NO];
}

+(NSArray*)dictionaryArrayFromJsonArray:(NSString*)jsonString withLog:(BOOL)isLog{
    //To dictionary
    NSArray *jsonObjectArray = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                               options:0 error:NULL];
    if (isLog) {
        int i =1;
        for (NSDictionary *dic in jsonObjectArray){
            NSLog(@"%d: %@,%@,%@,%@",i,dic[@"name"],dic[@"phone"],dic[@"address"],dic[@"lat"]);
            i++;
        }
    }
    return jsonObjectArray;
};


@end


@implementation IceCreamSite

-(id)init{

    self = [super init];
    if (self) {
        
        self.name = nil;
        self.phone = nil;

    }
    return self;
}

-(id)initFromDictionary:(NSDictionary*)dictionary{

    self = [super init];
    if (self) {
        
        self.name = dictionary[@"name"];
        self.phone = dictionary[@"phone"];
        self.location = CLLocationCoordinate2DMake([dictionary[@"lat"] doubleValue], [dictionary[@"lng"] doubleValue]);
    }
    return self;
}




@end