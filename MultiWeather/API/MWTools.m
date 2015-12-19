//
//  MWTools.m
//  MultiWeather
//
//  Created by AIrza on 04/07/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWTools.h"

@implementation MWTools
                
+(id)fahrenheitFromCelsius:(NSNumber *)celsius
{
    return [NSNumber numberWithFloat:([celsius floatValue] * 1.8f + 32.f)];
}

@end
