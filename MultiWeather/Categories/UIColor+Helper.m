//
//  UIColor+Helper.m
//  MultiWeather
//
//  Created by AIrza on 17/06/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "UIColor+Helper.h"

@implementation UIColor (Helper)

+(UIColor *)colorWithR:(int)r G:(int)g B:(int)b
{
    return [UIColor colorWithR:r G:g B:b A:100];
}

+(UIColor *)colorWithR:(int)r G:(int)g B:(int)b A:(int)a
{
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/100.0f];
}

@end
