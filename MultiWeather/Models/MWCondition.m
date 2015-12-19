//
//  MWCondition.m
//  MultiWeather
//
//  Created by AIrza on 19/06/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWCondition.h"
#import "MWTools.h"
#import "MWSettings.h"

@implementation MWCondition

-(NSNumber *)temperature
{
    if ([MWSettings getDefaultTemperatureUnit] == FahrenheitUnit) {
        return [MWTools fahrenheitFromCelsius:_temperature];
    } else {
        return _temperature;
    }
}

-(void)dealloc
{
    [_date release];
    [_temperature release];
    [_tempMax release];
    [_tempMin release];
    [_humidity release];
    [_windSpeed release];
    [_condition release];
    [_imageName release];
    [super dealloc];
}

@end
