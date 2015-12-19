//
//  MWWeatherAPIClient.m
//  MultiWeather
//
//  Created by AIrza on 6/21/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWWeatherAPIClient.h"
#import "MWWeatherUndergroundWeather.h"
#import "MWWorldWeatherOnlineWeather.h"
#import "MWOpenWeatherMapWeather.h"
#import "MWForecastIOWeather.h"
#import "MWYahooWeather.h"
#import "MWConstants.h"
#import "MWXmlParser.h"

@implementation MWWeatherAPIClient


#pragma mark - Load data for wunderground.com

-(NSURLRequest *)requestForWeatherUndergroundWithLocation: (MWLocation *)location
{
    NSString *baseURL = @"http://api.wunderground.com/api/";
    NSString *parameters = @"/forecast10day/conditions/q/";
    NSString *key = @"84765e246bffc38c";
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@%@%@,%@.json", baseURL, key, parameters, location.latitude, location.longitude];

    NSLog(@"WeatherUnderground request: %@", requestURL);
    NSURL *url = [NSURL URLWithString:requestURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    return request;
}

-(void)fetchWeatherForWeatherUndergroundWithLocation:(MWLocation *)location success:(MWWeatherFetchSuccesfull)success failure:(MWWeatherFetchFailure)failure
{
    if (!location) {
        return;
    }
    
    NSURLRequest *request = [self requestForWeatherUndergroundWithLocation:location];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            if (failure)
                failure(connectionError);
        } else {
            NSError *error = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            NSLog(@"WeatherUnderground: %@", json);
            NSDictionary *response = [json objectForKey:@"response"];
            if (response == nil) {
                if (failure) {
                    failure([NSError errorWithDomain:MW_ERROR_DOMAIN code:101 userInfo:@{NSLocalizedDescriptionKey: MW_ERROR_NO_RESPONSE}]);
                }
            } else {
                NSDictionary *error = response[@"error"];
                if (error != nil) {
                    if (failure) {
                        failure([NSError errorWithDomain:MW_ERROR_DOMAIN code:102 userInfo:@{NSLocalizedDescriptionKey: error[@"description"]}]);
                    }
                } else {

                    MWWeatherUndergroundWeather *weather = [MWWeatherUndergroundWeather weatherFromDictionary:json];
                    if (success) {
                        success(weather);
                    }
                }
            }
        }
    }];
}

#pragma mark - Load data for worldweatheronline.com

-(NSURLRequest *)requestForWorldWeatherOnlineWithLocation: (MWLocation *)location
{
    NSString *baseURL = @"http://api.worldweatheronline.com/free/v1/weather.ashx?";
    NSString *parameters = @"&type=latlon&format=json&num_of_days=5";
    NSString *key = @"&key=4030252abdb81c34792b6f848e8dc528d7b71ddb";
    
    NSString *requestURL = [NSString stringWithFormat:@"%@&lat=%.6f&lon=%.6f%@%@", baseURL, [location.latitude floatValue], [location.longitude floatValue], parameters, key];
    
    NSLog(@"WorldWeatherOnline request: %@", requestURL);
    NSURL *url = [NSURL URLWithString:requestURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    return request;
}


-(void)fetchWeatherForWorldWeatherOnlineWithLocation:(MWLocation *)location success:(MWWeatherFetchSuccesfull)success failure:(MWWeatherFetchFailure)failure
{
    if (!location) {
        return;
    }
    
    NSURLRequest *request = [self requestForWorldWeatherOnlineWithLocation:location];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            if (failure)
                failure(connectionError);
        } else {
            NSError *error = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            NSLog(@"WorldWeatherOnline: %@", json);
            
            if ([[json objectForKey:@"Response"] isEqualToString:@"False"]) {
                if (failure) {
                    failure([NSError errorWithDomain:MW_ERROR_DOMAIN code:101 userInfo:@{NSLocalizedDescriptionKey: MW_ERROR_NO_RESPONSE}]);
                }
            } else {
            
                NSDictionary *responseData = json[@"data"];
                NSArray *errorData = responseData[@"error"];
                if (errorData != nil) {
                    if (failure) {
                        failure([NSError errorWithDomain:MW_ERROR_DOMAIN code:101 userInfo:@{NSLocalizedDescriptionKey: [errorData firstObject][@"msg"]}]);
                    }
                } else {
                    MWWorldWeatherOnlineWeather *weather = [MWWorldWeatherOnlineWeather weatherFromDictionary:responseData];
                    if (success) {
                        success(weather);
                    }
                }
            }
        }
    }];
}

#pragma Load data for openweathermap.org

-(NSURLRequest *)requestForOpenWeatherMapWithLocation: (MWLocation *)location
{
    NSString *baseURL = @"http://api.openweathermap.org/data/2.5/forecast/daily?";
    NSString *parameters = @"&units=metric&cnt=6&mode=json";
    NSString *key = @"&APPID=a83c80847de9ca8eae0744bca749f31f";
    
    NSString *requestURL = [NSString stringWithFormat:@"%@lat=%@&lon=%@%@%@", baseURL, location.latitude, location.longitude, parameters, key];
    
    NSLog(@"OpenWeatherMap request: %@", requestURL);
    NSURL *url = [NSURL URLWithString:requestURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    return request;
}

-(void)fetchWeatherForOpenWeatherMapWithLocation:(MWLocation *)location success:(MWWeatherFetchSuccesfull)success failure:(MWWeatherFetchFailure)failure
{
    if (!location) {
        return;
    }
    
    NSURLRequest *request = [self requestForOpenWeatherMapWithLocation:location];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            if (failure)
                failure(connectionError);
        } else {
            NSError *error = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            NSLog(@"OpenWeatherMap: %@", json);
            if (![json[@"cod"] isEqualToString:@"200"]) {
                if (failure) {
                    failure([NSError errorWithDomain:MW_ERROR_DOMAIN code:102 userInfo:@{NSLocalizedDescriptionKey: json[@"message"]}]);
                }
            } else {
                
                MWOpenWeatherMapWeather *weather = [MWOpenWeatherMapWeather weatherFromDictionary:json];
                if (success) {
                    success(weather);
                }
            }
        }
    }];
}

#pragma Load data for forecast.io (info https://developer.forecast.io/docs/v2)

-(NSURLRequest *)requestForForecastIOWithLocation: (MWLocation *)location
{
    NSString *baseURL = @"https://api.forecast.io/forecast/";
    NSString *parameters = @"?units=si&exclude=minutely,hourly,alerts,flags";
    NSString *key = @"f218df550f34e35bada71d5b20486d45";
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@/%.6f,%.6f%@", baseURL, key, [location.latitude floatValue], [location.longitude floatValue], parameters];
    
    NSLog(@"ForecastIO request: %@", requestURL);
    NSURL *url = [NSURL URLWithString:requestURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    return request;
}

-(void)fetchWeatherForForecastIOWithLocation:(MWLocation *)location success:(MWWeatherFetchSuccesfull)success failure:(MWWeatherFetchFailure)failure
{
    if (!location) {
        return;
    }
    
    NSURLRequest *request = [self requestForForecastIOWithLocation:location];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            if (failure)
                failure(connectionError);
        } else {
            NSError *error = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            NSLog(@"ForecastIO: %@", json);
            
            if ( [json objectForKey:@"error"] != nil) {
                if (failure) {
                    failure([NSError errorWithDomain:MW_ERROR_DOMAIN code:101 userInfo:@{NSLocalizedDescriptionKey: [json objectForKey:@"error"]}]);
                }
            } else {
            
                MWForecastIOWeather *weather = [MWForecastIOWeather weatherFromDictionary:json];
                if (success) {
                    success(weather);
                }
            }
        }
    }];
}

#pragma Load data for Yahoo.com

-(NSURLRequest *)requestForYahooWithLocation:(MWLocation *)location
{
    NSString *baseURL =@"https://query.yahooapis.com/v1/public/yql?q=select * from weather.woeid where w in (select woeid from geo.placefinder(1) where text='%.6f,%.6f' and gflags='R') and u='c'&env=store://datatables.org/alltableswithkeys";
    
    NSString *requestURL = [NSString stringWithFormat:baseURL, [location.latitude floatValue], [location.longitude floatValue]];
    
    NSLog(@"Yahoo request: %@", requestURL);
    NSURL *url = [NSURL URLWithString:[requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    return request;
}

-(void)fetchWeatherForYahooWithLocation:(MWLocation *)location success:(MWWeatherFetchSuccesfull)success failure:(MWWeatherFetchFailure)failure
{
    if (!location) {
        return;
    }
    
    NSURLRequest *request = [self requestForYahooWithLocation:location];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            if (failure)
                failure(connectionError);
        } else {
            NSError *error = nil;
            NSDictionary *xml = [MWXmlParser dictionaryForXmlData:data error:&error];
            
            NSLog(@"Yahoo: %@", xml);
            
            NSDictionary *responseData = xml[@"query"][@"results"];
            
            if ( responseData == nil) {
                if (failure) {
                    failure([NSError errorWithDomain:MW_ERROR_DOMAIN code:101 userInfo:@{NSLocalizedDescriptionKey: MW_ERROR_NO_RESPONSE}]);
                }
            } else {
                NSLog(@"Yahoo: %@", responseData[@"rss"]);
                MWYahooWeather *weather = [MWYahooWeather weatherFromDictionary:responseData[@"rss"]];
                if (success) {
                    success(weather);
                }
            }
        }
    }];
}


@end
