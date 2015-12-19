//
//  NSNotificationCenter+Helper.m
//  MultiWeather
//
//  Created by AIrza on 12/07/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "NSNotificationCenter+Helper.h"

@implementation NSNotificationCenter (Helper)

- (void)addUniqueObserver:(id)observer selector:(SEL)selector name:(NSString *)name object:(id)object
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:object];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:object];
}

@end
