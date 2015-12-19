//
//  MWDailyForecast.h
//  MultiWeather
//
//  Created by AIrza on 02/07/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWDailyForecast : NSObject

@property(nonatomic, retain) NSDate *date;
@property(nonatomic, retain) NSNumber *tempMax;
@property(nonatomic, retain) NSNumber *tempMin;
@property(nonatomic, retain) NSString *imageName;

@end
