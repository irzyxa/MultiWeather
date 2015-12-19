//
//  MWWeatherPageViewController.h
//  MultiWeather
//
//  Created by AIrza on 6/13/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWLocation.h"

@interface MWWeatherPageViewController : UIViewController<UIPageViewControllerDataSource>

@property (nonatomic, retain) UIPageViewController *weatherPageViewController;
@property (nonatomic, assign) MWLocation *location;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (retain, nonatomic) IBOutlet UILabel *servicesNotFoundLabel;

- (IBAction)refreshPressed:(id)sender;

@end
