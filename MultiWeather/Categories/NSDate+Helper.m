//
//  NSDate+Helper.m
//  MultiWeather
//
//  Created by AIrza on 04/07/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

-(BOOL)isSameDay:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents *comp2 = [calendar components:unitFlags fromDate:date];
    
    return [comp1 day] == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year] == [comp2 year];
}

-(BOOL)isSameMonth:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents *comp2 = [calendar components:unitFlags fromDate:date];
    
    return [comp1 month] == [comp2 month] &&
    [comp1 year] == [comp2 year];
}

-(BOOL)isSameYear:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents *comp2 = [calendar components:unitFlags fromDate:date];
    
    return [comp1 year] == [comp2 year];
}

@end
