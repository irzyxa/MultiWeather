//
//  MWSettings.h
//  MultiWeather
//
//  Created by AIrza on 17/06/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWLocation.h"
#import "MWConstants.h"

typedef enum TemperatureUnits: NSInteger TemperatureUnits;
enum TemperatureUnits : NSInteger {
    CelsiusUnit,
    FahrenheitUnit
};

@interface MWSettings : NSObject

+(void)removeParameter:(NSString *)parameter;

+(void)setValue:(id)value forParameter:(NSString *)parameter;
+(void)setObject:(id)value forParameter:(NSString *)parameter;
+(void)setIntegerValue:(NSInteger)integerValue forParameter:(NSString *)parameter;
+(void)setBoolValue:(BOOL)boolValue forParameter:(NSString *)parameter;

+(id)getValueForParameter:(NSString *)parameter;
+(id)getObjectForParameter:(NSString *)parameter;
+(NSInteger)getIntegerValueForParameter:(NSString *)parameter;
+(BOOL)getBoolValueForParameter:(NSString *)parameter;

+(void)setDefaultLocation:(MWLocation *)location;
+(MWLocation *)getDefaultLocation;

+(void)setWeatherServices:(NSMutableArray *)services;
+(NSMutableArray *)getWeatherServices;

+(void)setDefaultTemperatureUnit:(TemperatureUnits)defaultUnit;
+(TemperatureUnits)getDefaultTemperatureUnit;

@end
