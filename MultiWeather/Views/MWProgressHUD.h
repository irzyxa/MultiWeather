//
//  MWProgressHUD.h
//  MultiWeather
//
//  Created by AIrza on 7/1/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWProgressHUD : UIView

@property(nonatomic, retain) NSString *title;

+ (MWProgressHUD *)showHUDForView:(UIView *)view;
+ (void)hideHUDForView:(UIView *)view;

@end
