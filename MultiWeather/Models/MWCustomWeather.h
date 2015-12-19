//
//  MWCustomWeather.h
//  MultiWeather
//
//  Created by AIrza on 6/13/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWCondition.h"
#import "MWLocation.h"

@interface MWCustomWeather : NSObject

@property(nonatomic, retain) NSString *serviceName;
@property(nonatomic, retain) NSString *serviceLogoImageName;
@property(nonatomic, retain) MWCondition *currentCondition;
@property(nonatomic, retain) NSMutableArray *hourlyForecast;
@property(nonatomic, retain) NSMutableArray *dailyForecast;
@property(nonatomic, retain) NSDate *lastUpdateDateTime;

-(id)initWithDictionary: (NSDictionary *) data;

+(id)weatherFromDictionary: (NSDictionary *)data;

@end
