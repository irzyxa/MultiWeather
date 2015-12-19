//
//  MWOpenWeatherMapWeather.m
//  MultiWeather
//
//  Created by AIrza on 6/14/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWOpenWeatherMapWeather.h"
#import "MWConstants.h"
#import "MWDailyForecast.h"
#import "NSString+Helper.h"

@implementation MWOpenWeatherMapWeather

-(id)init
{
    if (self = [super init]) {
        self.serviceName = MW_WEATHER_SERVISE_OWM;
        self.serviceLogoImageName = MW_WEATHER_SERVISE_OWM_LOGO;
    }
    
    return  self;
}

- (NSString *)weatherImageNameFromString: (NSString *)weather
{
    if ([weather contains:@"01d"]) {
        return @"sunny";
    } else if ([weather contains:@"01n"]) {
        return @"clear_night";
    } else if ([weather contains:@"02d"]) {
        return @"cloudy";
    } else if ([weather contains:@"02n"]) {
        return @"heavy_cloudy_night";
    } else if ([weather contains:@"03d"] ||
               [weather contains:@"03n"]) {
        return @"overcast";
    } else if ([weather contains:@"04d"] ||
               [weather contains:@"04n"]) {
        return @"broken_clouds";
    } else if ([weather contains:@"09d"] ||
               [weather contains:@"09n"]) {
        return @"heavy_rain";
    } else if ([weather contains:@"10d"]) {
        return @"rain_sun";
    } else if ([weather contains:@"10n"]) {
        return @"night_rain";
    } else if ([weather contains:@"11d"]) {
        return @"rain_thunder_sun";
    } else if ([weather contains:@"11n"]) {
        return @"night_rain_thunder";
    } else if ([weather contains:@"13d"]) {
        return @"snow";
    } else if ([weather contains:@"13n"]) {
        return @"snow_night";
    } else if ([weather contains:@"50d"]) {
        return @"foggy";
    } else if ([weather contains:@"50n"]) {
        return @"fog_night";
    } else
        return @"cloudy";
}

-(id)initWithDictionary:(NSDictionary *)data
{
    if (self = [super init]) {
        self.serviceName = MW_WEATHER_SERVISE_OWM;
        self.serviceLogoImageName = MW_WEATHER_SERVISE_OWM_LOGO;

        NSLog(@"OpenWeatherMap initWithDictionary %@", data);
        
        NSArray *currentData = [data valueForKey:@"list"];
        for (int i = 0; i < currentData.count; i++) {
            NSDictionary *currentObservation = currentData[i];
            //Fill today weather
            if (i == 0) {
//                self.currentCondition.date =  [NSDate dateWithTimeIntervalSince1970: [[currentObservation valueForKey:@"dt"] intValue]];
                self.currentCondition.date = [NSDate date];
                self.currentCondition.temperature = [[currentObservation valueForKey:@"temp"] valueForKey:@"day"];
                self.currentCondition.humidity = [currentObservation valueForKey:@"humidity"];
                self.currentCondition.windSpeed = [currentObservation valueForKey:@"speed"];
                self.currentCondition.imageName = [self weatherImageNameFromString:[[[currentObservation valueForKey:@"weather"] firstObject] valueForKey:@"icon"]];
            }
            
            MWDailyForecast *forecast = [[MWDailyForecast alloc] init];
            
            forecast.tempMax = [[currentObservation valueForKey:@"temp"] valueForKey:@"max"];
            forecast.tempMin = [[currentObservation valueForKey:@"temp"] valueForKey:@"min"];
            forecast.date =  [NSDate dateWithTimeIntervalSince1970: [[currentObservation valueForKey:@"dt"] intValue]];
            forecast.imageName = [self weatherImageNameFromString:[[[currentObservation valueForKey:@"weather"] firstObject] valueForKey:@"icon"]];
            
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
