//
//  MWCustomWeather.m
//  MultiWeather
//
//  Created by AIrza on 6/13/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWCustomWeather.h"

@implementation MWCustomWeather

-(id)init
{
    if (self = [super init]) {
        self.currentCondition = [[[MWCondition alloc] init] autorelease];
        self.dailyForecast = [NSMutableArray array];
        self.hourlyForecast = [NSMutableArray array];
        self.lastUpdateDateTime = [[[NSDate alloc] init] autorelease];
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)data
{
    return nil;
}

+(id)weatherFromDictionary:(NSDictionary *)data
{
    return nil;
}

-(void)dealloc
{
    [_serviceName release];
    [_serviceLogoImageName release];
    [_currentCondition release];
    [_hourlyForecast release];
    [_dailyForecast release];
    [super dealloc];
}

@end
