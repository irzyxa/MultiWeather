//
//  MWWorldWeatherOnlineWeather.m
//  MultiWeather
//
//  Created by AIrza on 6/23/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWWorldWeatherOnlineWeather.h"
#import "MWConstants.h"
#import "MWDailyForecast.h"
#import "NSString+Helper.h"

@implementation MWWorldWeatherOnlineWeather

- (id)init
{
    if (self = [super init]) {
        self.serviceName = MW_WEATHER_SERVISE_WWO;
        self.serviceLogoImageName = MW_WEATHER_SERVISE_WWO_LOGO;
    }
    
    return self;
}

- (NSString *)weatherImageNameFromString: (NSString *)weather
{
    if ([weather contains:@"113"]) {
        return @"sunny";
    } else if ([weather contains:@"116"]) {
        return @"partly_cloudy";
    } else if ([weather contains:@"119"]) {
        return @"cloudy";
    } else if ([weather contains:@"122"]) {
        return @"overcast";
    } else if ([weather contains:@"143"] ||
               [weather contains:@"248"] ||
               [weather contains:@"260"]) {
        return @"foggy";
    } else if ([weather contains:@"176"] ||
               [weather contains:@"263"] ||
               [weather contains:@"353"]) {
        return @"rain_sun";
    } else if ([weather contains:@"179"] ||
               [weather contains:@"362"] ||
               [weather contains:@"365"] ||
               [weather contains:@"374"]) {
        return @"rain_snow";
    } else if ([weather contains:@"182"] ||
               [weather contains:@"185"]) {
        return @"snow_sun";
    } else if ([weather contains:@"200"] ||
               [weather contains:@"386"]) {
        return @"rain_thunder";
    } else if ([weather contains:@"227"]) {
        return @"partly_cloudy";
    } else if ([weather contains:@"299"] ||
               [weather contains:@"305"] ||
               [weather contains:@"356"]) {
        return @"rain";
    } else if ([weather contains:@"323"] ||
               [weather contains:@"326"] ||
               [weather contains:@"368"] ||
               [weather contains:@"227"] ||
               [weather contains:@"320"]) {
        return @"snow";
    } else if ([weather contains:@"335"] ||
               [weather contains:@"371"] ||
               [weather contains:@"395"] ||
               [weather contains:@"230"] ||
               [weather contains:@"329"] ||
               [weather contains:@"332"] ||
               [weather contains:@"338"]) {
        return @"heavysnow";
    } else if ([weather contains:@"392"]) {
        return @"snow_thunder_sun";
    } else if ([weather contains:@"266"] ||
               [weather contains:@"293"] ||
               [weather contains:@"296"]) {
        return @"rain";
    } else if ([weather contains:@"302"] ||
               [weather contains:@"308"] ||
               [weather contains:@"359"]) {
        return @"heavy_rain";
    } else if ([weather contains:@"281"] ||
               [weather contains:@"284"] ||
               [weather contains:@"311"] ||
               [weather contains:@"314"] ||
               [weather contains:@"317"] ||
               [weather contains:@"350"]) {
        return @"ice";
    } else if ([weather contains:@"389"]) {
        return @"tornado";
    }
        return @"cloudy";
}

- (id)initWithDictionary:(NSDictionary *)data
{
    if (self = [super init]) {
        self.serviceName = MW_WEATHER_SERVISE_WWO;
        self.serviceLogoImageName = MW_WEATHER_SERVISE_WWO_LOGO;
        
        NSDictionary *currentObservation = [[data valueForKey:@"current_condition"] firstObject];
        self.currentCondition.date = [NSDate date];
        self.currentCondition.temperature = currentObservation[@"temp_C"];
        self.currentCondition.humidity = currentObservation[@"humidity"];
        self.currentCondition.windSpeed = currentObservation[@"windspeedKmph"];
        self.currentCondition.imageName = [self weatherImageNameFromString:currentObservation[@"weatherCode"]];
        
        NSArray *forecastList = data[@"weather"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        for (int i = 0; i < forecastList.count; i++) {
            NSDictionary *forecastDay = forecastList[i];
            
            MWDailyForecast *forecast = [[MWDailyForecast alloc] init];
            
            forecast.tempMax = forecastDay[@"tempMaxC"];
            forecast.tempMin = forecastDay[@"tempMinC"];
            forecast.date =  [dateFormatter dateFromString:forecastDay[@"date"]];
            forecast.imageName = [self weatherImageNameFromString:forecastDay[@"weatherCode"]];
            
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
