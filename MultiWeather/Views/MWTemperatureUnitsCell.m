//
//  MWTemperatureUnitsCell.m
//  MultiWeather
//
//  Created by AIrza on 14/07/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWTemperatureUnitsCell.h"

@implementation MWTemperatureUnitsCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_defaultTemperatureUnitSegControl release];
    [super dealloc];
}

- (IBAction)defaultTemperatureUnitChanged:(id)sender
{
    if (self.delegate  && [self.delegate respondsToSelector:@selector(temperatureUnitsCell:defaultTemperatureUnitChangedTo:)]) {
        [self.delegate temperatureUnitsCell:self defaultTemperatureUnitChangedTo:self.defaultTemperatureUnitSegControl.selectedSegmentIndex];
    }
}

@end
