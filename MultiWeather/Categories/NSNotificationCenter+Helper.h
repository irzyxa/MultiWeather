//
//  NSNotificationCenter+Helper.h
//  MultiWeather
//
//  Created by AIrza on 12/07/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (Helper)
- (void)addUniqueObserver:(id)observer selector:(SEL)selector name:(NSString *)name object:(id)object;

@end
