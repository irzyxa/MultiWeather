//
//  MWLocation.h
//  MultiWeather
//
//  Created by AIrza on 6/6/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWLocation : NSObject <NSCoding>

@property(nonatomic, retain) NSString *cityName;
@property(nonatomic, retain) NSString *adminName;
@property(nonatomic, retain) NSString *countryName;
@property(nonatomic, retain) NSString *countryCode;
@property(nonatomic, retain) NSString *regionName;
@property(nonatomic, retain) NSNumber *longitude;
@property(nonatomic, retain) NSNumber *latitude;

-(id)initWithDictionary:(NSDictionary *) data;
+(id)locationFromDictionary:(NSDictionary *) data;

@end
