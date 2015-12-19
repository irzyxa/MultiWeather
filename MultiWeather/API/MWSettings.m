//
//  MWSettings.m
//  MultiWeather
//
//  Created by AIrza on 17/06/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWSettings.h"

@implementation MWSettings


+(void)removeParameter:(NSString *)parameter
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:parameter];
    [defaults synchronize];
}

+(void)setValue:(id)value forParameter:(NSString *)parameter
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:parameter];
    [defaults synchronize];
}

+(void)setObject:(id)value forParameter:(NSString *)parameter
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:parameter];
    [defaults synchronize];
}

+(void)setIntegerValue:(NSInteger)integerValue forParameter:(NSString *)parameter
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:integerValue forKey:parameter];
    [defaults synchronize];
}

+(void)setBoolValue:(BOOL)boolValue forParameter:(NSString *)parameter
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:boolValue forKey:parameter];
    [defaults synchronize];
}

+(id)getValueForParameter:(NSString *)parameter
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:parameter];
}

+(id)getObjectForParameter:(NSString *)parameter
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:parameter];
}

+(NSInteger)getIntegerValueForParameter:(NSString *)parameter
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:parameter];
}

+(BOOL)getBoolValueForParameter:(NSString *)parameter
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:parameter];
}

+(void)setWeatherServices:(NSMutableArray *)services
{
    [MWSettings setObject:[NSKeyedArchiver archivedDataWithRootObject:services] forParameter:MW_SETTINGS_WEATHER_SERVICES];
    
}

+(NSMutableArray *)getWeatherServices
{
    NSData *data = [MWSettings getObjectForParameter:MW_SETTINGS_WEATHER_SERVICES];
    if (data != nil) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        NSMutableDictionary *item2 = [[NSMutableDictionary alloc]initWithObjects: @[MW_WEATHER_SERVISE_OWM, MW_WEATHER_SERVISE_OWM_LOGO, [NSNumber numberWithBool:YES]] forKeys:@[MW_SERVICE_NAME, MW_SERVICE_LOGO, MW_SERVICE_USE]];
        NSMutableDictionary *item5 = [[NSMutableDictionary alloc]initWithObjects: @[MW_WEATHER_SERVISE_WWO, MW_WEATHER_SERVISE_WWO_LOGO, [NSNumber numberWithBool:YES]] forKeys:@[MW_SERVICE_NAME, MW_SERVICE_LOGO, MW_SERVICE_USE]];
        NSMutableDictionary *item3 = [[NSMutableDictionary alloc]initWithObjects: @[MW_WEATHER_SERVISE_WU, MW_WEATHER_SERVISE_WU_LOGO, [NSNumber numberWithBool:YES]] forKeys:@[MW_SERVICE_NAME, MW_SERVICE_LOGO, MW_SERVICE_USE]];
        NSMutableDictionary *item4 = [[NSMutableDictionary alloc]initWithObjects: @[MW_WEATHER_SERVISE_FIO, MW_WEATHER_SERVISE_FIO_LOGO, [NSNumber numberWithBool:YES]] forKeys:@[MW_SERVICE_NAME, MW_SERVICE_LOGO, MW_SERVICE_USE]];
        NSMutableDictionary *item1 = [[NSMutableDictionary alloc]initWithObjects: @[MW_WEATHER_SERVISE_YAHOO, MW_WEATHER_SERVISE_YAHOO_LOGO, [NSNumber numberWithBool:YES]] forKeys:@[MW_SERVICE_NAME, MW_SERVICE_LOGO, MW_SERVICE_USE]];
        
        return [NSMutableArray arrayWithObjects: [item1 autorelease], [item2 autorelease], [item3 autorelease], [item4 autorelease], [item5 autorelease], nil];
    }
}

+(void)setDefaultLocation:(id)location
{
    [MWSettings setObject:[NSKeyedArchiver archivedDataWithRootObject:location] forParameter:MW_SETTINGS_DEFAULT_LOCATION];
}

+(MWLocation *)getDefaultLocation
{
    NSData *data = [MWSettings getObjectForParameter:MW_SETTINGS_DEFAULT_LOCATION];
    if (data != nil) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        return [[[MWLocation alloc] init] autorelease];
    }
}

+(void)setDefaultTemperatureUnit:(TemperatureUnits)defaultUnit
{
    [MWSettings setIntegerValue:defaultUnit forParameter:MW_SETTINGS_DEFAULT_TEMPERATURE_UNIT];
}

+(TemperatureUnits)getDefaultTemperatureUnit
{
    return [MWSettings getIntegerValueForParameter:MW_SETTINGS_DEFAULT_TEMPERATURE_UNIT];
}

@end
