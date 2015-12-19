//
//  UIAlertView+Helper.m
//  MultiWeather
//
//  Created by AIrza on 18/06/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "UIAlertView+Helper.h"

@implementation UIAlertView (Helper)

+ (void)showAlertViewWithCustomErrorMessage:(NSString *)errorMessage
                                      title:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert autorelease];
}

@end
