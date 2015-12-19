//
//  UIAlertView+Helper.h
//  MultiWeather
//
//  Created by AIrza on 18/06/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Helper)

+ (void)showAlertViewWithCustomErrorMessage:(NSString *)errorMessage
                                      title:(NSString *)title;
@end
