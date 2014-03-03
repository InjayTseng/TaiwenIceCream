//
//  IceCreamReader.h
//  TaiwenIceCream
//
//  Created by David Tseng on 2/26/14.
//  Copyright (c) 2014 David Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
enum {
    kKeelungCity = 1,		/* 0..127 only */
    kTaipeiCity = 2,
    kNewTaipeiCity = 3,
    kTaoyuan	 = 4,
    kHsinchu = 5,
    kHsinchuCity  = 6,
    kMiaoli = 7,
    kTaichungCity = 8,          /* kCFStringEncodingDOSJapanese */
    kChanghua = 9,
    kYunlin = 10,
    kNantou = 11,    /* Cyrillic; same as AdobeStandardCyrillic */
    kChiayi = 12,    /* WinLatin1 */
    kChiayiCity = 13,    /* Greek */
    kTainanCity = 14,    /* Turkish */
    kKaoshiungCity = 15,    /* WinLatin2 */
    kPingtung = 16,        /* ISO 2022 Japanese encoding for e-mail */
    kYilanCity = 17,
    kHualienCity = 18,
    kTaitung = 19,
    kPenghu = 20,
    kKinmen = 21,
    kMatsu = 22
};

@interface IceCreamReader : NSObject

+(NSDictionary*)supportingDictionary;

+(NSArray*)arrayFromFamilyMartAll;
+(NSArray*)arrayFrom711All;


+(NSArray*)arrayFromFamilyMartWithPlaceName:(NSString*)place;
+(NSArray*)arrayFrom711WithPlaceName:(NSString*)place;

@end


@interface IceCreamSite: NSObject
@property(nonatomic,strong) NSString* type;
@property(nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSString* phone;
@property(nonatomic,readwrite) CLLocationCoordinate2D location;

-(id)initFromDictionary:(NSDictionary*)dictionary;

@end


