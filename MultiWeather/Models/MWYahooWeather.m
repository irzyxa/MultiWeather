//
//  MWYahooWeather.m
//  MultiWeather
//
//  Created by AIrza on 7/6/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWYahooWeather.h"
#import "MWDailyForecast.h"
#import "MWConstants.h"

@implementation MWYahooWeather

-(id)init
{
    if (self = [super init]) {
        self.serviceName = MW_WEATHER_SERVISE_YAHOO;
        self.serviceLogoImageName = MW_WEATHER_SERVISE_YAHOO_LOGO;
    }
    
    return self;
}

-(NSString *)weatherImageNameFromString: (NSString *)weather
{
    if ([weather isEqualToString:@"0"]) {
        return @"tornado";
    } else if ([weather isEqualToString:@"1"] ||
               [weather isEqualToString:@"2"]) {
        return @"rain_tornado";
    } else if ([weather isEqualToString:@"3"] ||
               [weather isEqualToString:@"4"]) {
        return @"rain_thunder_sun";
    } else if ([weather isEqualToString:@"5"] ||
               [weather isEqualToString:@"18"]) {
        return @"rain_snow";
    } else if ([weather isEqualToString:@"6"] ||
               [weather isEqualToString:@"17"] ||
               [weather isEqualToString:@"35"]) {
        return @"ice";
    } else if ([weather isEqualToString:@"7"]) {
        return @"ice_snow";
    } else if ([weather isEqualToString:@"8"] ||
               [weather isEqualToString:@"9"] ||
               [weather isEqualToString:@"10"] ||
               [weather isEqualToString:@"11"] ||
               [weather isEqualToString:@"12"] ||
               [weather isEqualToString:@"40"] ||
               [weather isEqualToString:@"45"]) {
        return @"rain";
    } else if ([weather isEqualToString:@"13"] ||
               [weather isEqualToString:@"14"] ||
               [weather isEqualToString:@"15"] ||
               [weather isEqualToString:@"16"] ||
               [weather isEqualToString:@"46"]) {
        return @"snow";
    } else if ([weather isEqualToString:@"20"] ||
               [weather isEqualToString:@"21"] ||
               [weather isEqualToString:@"22"] ) {
        return @"foggy";
    } else if ([weather isEqualToString:@"26"] ||
               [weather isEqualToString:@"28"] ||
               [weather isEqualToString:@"30"]) {
        return @"cloudy";
    } else if ([weather isEqualToString:@"27"] ||
               [weather isEqualToString:@"29"]) {
        return @"cloudy_night";
    } else if ([weather isEqualToString:@"31"] ||
               [weather isEqualToString:@"33"]) {
        return @"clear_night";
    } else if ([weather isEqualToString:@"32"] ||
               [weather isEqualToString:@"34"] ||
               [weather isEqualToString:@"36"]) {
        return @"sunny";
    } else if ([weather isEqualToString:@"37"] ||
               [weather isEqualToString:@"38"] ||
               [weather isEqualToString:@"39"] ||
               [weather isEqualToString:@"47"]) {
        return @"rain_thunder";
    } else if ([weather isEqualToString:@"41"] ||
               [weather isEqualToString:@"42"] ||
               [weather isEqualToString:@"43"]) {
        return @"heavysnow";
    } else if ([weather isEqualToString:@"44"]) {
        return @"partly_cloudy";
    } else
        return @"overcast";
}

-(id)initWithDictionary:(NSDictionary *)data
{
    if (self = [super init]) {
        self.serviceName = MW_WEATHER_SERVISE_YAHOO;
        self.serviceLogoImageName = MW_WEATHER_SERVISE_YAHOO_LOGO;
        
        NSDictionary *currentObservation = data[@"channel"];
        self.currentCondition.date = [NSDate date];
        self.currentCondition.temperature = currentObservation[@"item"][@"yweather:condition"][@"temp"];
        self.currentCondition.humidity = currentObservation[@"yweather:atmosphere"][@"humidity"];
        self.currentCondition.windSpeed = currentObservation[@"yweather:wind"][@"speed"];
        self.currentCondition.imageName = [self weatherImageNameFromString:currentObservation[@"item"][@"yweather:condition"][@"code"]];
        
        NSArray *forecastList = currentObservation[@"item"][@"yweather:forecast"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setLocale:locale];
        [dateFormatter setDateFormat:@"d MMM yyyy"];
        
        for (int i = 0; i < 5; i++) {
            NSDictionary *forecastDay = forecastList[i];
            
            MWDailyForecast *forecast = [[MWDailyForecast alloc] init];
            
            forecast.tempMax = forecastDay[@"high"];
            forecast.tempMin = forecastDay[@"low"];
            forecast.date =  [dateFormatter dateFromString:forecastDay[@"date"]];
            forecast.imageName = [self weatherImageNameFromString:forecastDay[@"code"]];
            
            [self.dailyForecast addObject:forecast];
            [forecast release];
        }
        
        [dateFormatter release];
    }
    
    return self;
}

+(id)weatherFromDictionary:(NSDictionary *)data
{
    return [[[self alloc] initWithDictionary:data] autorelease];
}

@end
