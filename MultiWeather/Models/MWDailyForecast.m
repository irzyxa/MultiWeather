//
//  MWDailyForecast.m
//  MultiWeather
//
//  Created by AIrza on 02/07/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWDailyForecast.h"
#import "MWTools.h"
#import "MWSettings.h"

@implementation MWDailyForecast

-(NSNumber *)tempMax
{
    if ([MWSettings getDefaultTemperatureUnit] == FahrenheitUnit) {
        return [MWTools fahrenheitFromCelsius:_tempMax];
    } else {
        return _tempMax;
    }
}

-(NSNumber *)tempMin
{
    if ([MWSettings getDefaultTemperatureUnit] == FahrenheitUnit) {
        return [MWTools fahrenheitFromCelsius:_tempMin];
    } else {
        return _tempMin;
    }
}

-(void)dealloc
{
    [_date release];
    [_tempMax release];
    [_tempMin release];
    [_imageName release];
    [super dealloc];
}

@end
