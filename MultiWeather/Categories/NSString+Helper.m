//
//  NSString+Helper.m
//  MultiWeather
//
//  Created by AIrza on 6/22/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

-(BOOL)contains:(NSString *)substring
{
    if ([[self uppercaseString] rangeOfString:[substring uppercaseString]].location !=NSNotFound) {
        return YES;
    }
    return NO;
}

@end
