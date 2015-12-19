//
//  MWForecastCell.m
//  MultiWeather
//
//  Created by AIrza on 7/2/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWForecastCell.h"

@implementation MWForecastCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)dealloc {
    [_weatherImageView release];
    [_tempMaxLabel release];
    [_tempMinLabel release];
    [_dayLabel release];
    [super dealloc];
}
@end
