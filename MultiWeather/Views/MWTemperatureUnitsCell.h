//
//  MWTemperatureUnitsCell.h
//  MultiWeather
//
//  Created by AIrza on 14/07/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWSettings.h"

@class MWTemperatureUnitsCell;

@protocol MWTemperatureUnitsDelegate <NSObject>

@optional
-(void)temperatureUnitsCell: (MWTemperatureUnitsCell *)cell defaultTemperatureUnitChangedTo: (TemperatureUnits)defaultUnit;

@end

@interface MWTemperatureUnitsCell : UITableViewCell


@property (retain, nonatomic) IBOutlet UISegmentedControl *defaultTemperatureUnitSegControl;
@property (assign, nonatomic) id<MWTemperatureUnitsDelegate>delegate;

- (IBAction)defaultTemperatureUnitChanged:(id)sender;

@end
