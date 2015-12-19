//
//  MWForecastIOWeather.m
//  MultiWeather
//
//  Created by AIrza on 05/07/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWForecastIOWeather.h"
#import "MWDailyForecast.h"
#import "MWConstants.h"
#import "NSString+Helper.h"

@implementation MWForecastIOWeather

-(id)init
{
    if (self = [super init]) {
        self.serviceName = MW_WEATHER_SERVISE_FIO;
        self.serviceLogoImageName = MW_WEATHER_SERVISE_FIO_LOGO;
    }
    
    return self;
}

-(NSString *)weatherImageNameFromString: (NSString *)weather
{
    if ([weather contains:@"clear-day"]) {
        return @"sunny";
    } else if ([weather contains:@"clear-night"]) {
        return @"clear_night";
    } else if ([weather contains:@"cloudy"]) {
        return @"cloudy";
    } else if ([weather contains:@"rain"]) {
        return @"rain";
    } else if ([weather contains:@"thunderstorm"]) {
        return @"rain_thunder_sun";
    } else if ([weather contains:@"snow"]) {
        return @"snow";
    } else if ([weather contains:@"tornado"]) {
        return @"tornado";
    } else if ([weather contains:@"hurricane"]) {
        return @"rain_tornado";
    } else if ([weather contains:@"partly-cloudy-day"]) {
        return @"partly_cloudy";
    } else if ([weather contains:@"partly-cloudy-night"]) {
        return @"cloudy_night";
    } else if ([weather contains:@"hail"]) {
        return @"ice";
    } else if ([weather contains:@"sleet"]) {
        return @"rain_snow";
    } else if ([weather contains:@"wind"]) {
        return @"foggy";
    } else if ([weather contains:@"fog"]) {
        return @"foggy";
    }
    return @"cloudy";
}


-(id)initWithDictionary:(NSDictionary *)data
{
    if (self = [super init]) {
        self.serviceName = MW_WEATHER_SERVISE_FIO;
        self.serviceLogoImageName = MW_WEATHER_SERVISE_FIO_LOGO;
        
        NSDictionary *currentObservation = data[@"currently"];
        self.currentCondition.date = [NSDate date];
        self.currentCondition.temperature = currentObservation[@"temperature"];
        self.currentCondition.humidity = [NSNumber numberWithFloat: [currentObservation[@"humidity"] floatValue] * 100.f];
        self.currentCondition.windSpeed = currentObservation[@"windSpeed"];
        self.currentCondition.imageName = [self weatherImageNameFromString:currentObservation[@"icon"]];
        
        NSArray *forecastList = data[@"daily"][@"data"];
        
        for (int i = 0; i < 5; i++) {
            NSDictionary *forecastDay = forecastList[i];
            
            MWDailyForecast *forecast = [[MWDailyForecast alloc] init];
            
            forecast.tempMax = forecastDay[@"temperatureMax"];
            forecast.tempMin = forecastDay[@"temperatureMin"];
            forecast.date =  [NSDate dateWithTimeIntervalSince1970: [forecastDay[@"time"] intValue]];
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
