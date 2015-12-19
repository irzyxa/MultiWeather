//
//  NSDate+Helper.h
//  MultiWeather
//
//  Created by AIrza on 04/07/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helper)

- (BOOL)isSameDay: (NSDate *)date;
- (BOOL)isSameMonth: (NSDate *)date;
- (BOOL)isSameYear: (NSDate *)date;

@end
