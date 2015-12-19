//
//  MWWeatherUndergroundWeather.m
//  MultiWeather
//
//  Created by AIrza on 6/22/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWWeatherUndergroundWeather.h"
#import "MWConstants.h"
#import "MWDailyForecast.h"
#import "NSString+Helper.h"

@implementation MWWeatherUndergroundWeather

-(id)init
{
    if (self = [super init]) {
        self.serviceName = MW_WEATHER_SERVISE_WU;
        self.serviceLogoImageName = MW_WEATHER_SERVISE_WU_LOGO;
    }
    
    return self;
}

-(NSString *)weatherImageNameFromString: (NSString *)weather
{
    if ([weather contains:@"clear"]) {
        return @"sunny";
    } else if ([weather contains:@"cloud"]) {
        return @"cloudy";
    } else if ([weather contains:@"drizzle"] ||
               [weather contains:@"rain"]) {
        return @"rain";
    } else if ([weather contains:@"thunderstorm"]) {
        return @"rain_thunder_sun";
    } else if ([weather contains:@"snow"]) {
        return @"snow";
    } else if ([weather contains:@"overcast"]) {
        return @"overcast";
    }
    return @"cloudy";
}

-(id)initWithDictionary: (NSDictionary *) data
{
    if (self = [super init]) {

        self.serviceName = MW_WEATHER_SERVISE_WU;
        self.serviceLogoImageName = MW_WEATHER_SERVISE_WU_LOGO;
        
        NSDictionary *currentObservation = [data objectForKey:@"current_observation"];
        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
//        self.currentCondition.date = [dateFormatter dateFromString:currentObservation[@"observation_time_rfc822"]];
//        [dateFormatter release];
        self.currentCondition.date = [NSDate date];
       
        self.currentCondition.temperature = currentObservation[@"temp_c"];
        
        //For humidity need remove %
        NSString *humidity = currentObservation[@"relative_humidity"];
        humidity = [humidity stringByTrimmingCharactersInSet:[NSCharacterSet symbolCharacterSet]];
        self.currentCondition.humidity =  [NSNumber numberWithFloat:[humidity floatValue]];
        
        self.currentCondition.windSpeed = currentObservation[@"wind_gust_kph"];
        
        self.currentCondition.imageName = [self weatherImageNameFromString:currentObservation[@"icon"]];
        
        NSArray *forecastList = data[@"forecast"][@"simpleforecast"][@"forecastday"];
        
        for (int i = 0; i < forecastList.count; i++) {
            NSDictionary *forecastDay = forecastList[i];
            
            MWDailyForecast *forecast = [[MWDailyForecast alloc] init];
            
            forecast.tempMax = [[forecastDay valueForKey:@"high"] valueForKey:@"celsius"];
            forecast.tempMin = [[forecastDay valueForKey:@"low"] valueForKey:@"celsius"];
            forecast.date =  [NSDate dateWithTimeIntervalSince1970: [forecastDay[@"date"][@"epoch"] intValue]];
            forecast.imageName = [self weatherImageNameFromString:forecastDay[@"icon"]];
            
            [self.dailyForecast addObject:forecast];
            [forecast release];
        }
    }
    
    return self;
}

+(id)weatherFromDictionary:(NSDictionary *)data
{
    return [[[self alloc] initWithDictionary:data] autorelease];
}

@end
