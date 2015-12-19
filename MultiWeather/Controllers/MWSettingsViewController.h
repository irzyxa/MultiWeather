//
//  MWSettingsViewController.h
//  MultiWeather
//
//  Created by AIrza on 17/06/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWAddLocationViewController.h"
#import "MWWeatherServiceCell.h"
#import "MWTemperatureUnitsCell.h"

@interface MWSettingsViewController : UITableViewController<MWAddLocationDelegate, MWWeatherServiceDelegate, MWTemperatureUnitsDelegate>

- (IBAction)camcelPressed:(id)sender;
- (IBAction)savePressed:(id)sender;

@end
