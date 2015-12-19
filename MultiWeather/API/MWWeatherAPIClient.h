//
//  MWWeatherAPIClient.h
//  MultiWeather
//
//  Created by AIrza on 6/21/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWLocation.h"
#import "MWCustomWeather.h"

//  Block Definition
typedef void (^MWWeatherFetchSuccesfull)(MWCustomWeather *weather);
typedef void (^MWWeatherFetchFailure)(NSError *error);


@interface MWWeatherAPIClient : NSObject

-(void)fetchWeatherForWeatherUndergroundWithLocation:(MWLocation *)location
                                             success:(MWWeatherFetchSuccesfull)success
                                             failure:(MWWeatherFetchFailure)failure;

-(void)fetchWeatherForWorldWeatherOnlineWithLocation:(MWLocation *)location
                                             success:(MWWeatherFetchSuccesfull)success
                                             failure:(MWWeatherFetchFailure)failure;

-(void)fetchWeatherForOpenWeatherMapWithLocation:(MWLocation *)location
                                         success:(MWWeatherFetchSuccesfull)success
                                         failure:(MWWeatherFetchFailure)failure;

-(void)fetchWeatherForForecastIOWithLocation:(MWLocation *)location
                                     success:(MWWeatherFetchSuccesfull)success
                                     failure:(MWWeatherFetchFailure)failure;

-(void)fetchWeatherForYahooWithLocation:(MWLocation *)location
                                success:(MWWeatherFetchSuccesfull)success
                                failure:(MWWeatherFetchFailure)failure;

@end
