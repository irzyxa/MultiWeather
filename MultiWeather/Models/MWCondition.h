//
//  MWCondition.h
//  MultiWeather
//
//  Created by AIrza on 19/06/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWCondition : NSObject

@property(nonatomic, retain) NSDate *date;
@property(nonatomic, retain) NSNumber *temperature;
@property(nonatomic, retain) NSNumber *tempMax;
@property(nonatomic, retain) NSNumber *tempMin;
@property(nonatomic, retain) NSNumber *windSpeed;
@property(nonatomic, retain) NSNumber *humidity;
@property(nonatomic, retain) NSString *condition;
@property(nonatomic, retain) NSString *imageName;

@end
