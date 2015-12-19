//
//  MWWeatherServiceCell.m
//  MultiWeather
//
//  Created by AIrza on 20/06/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWWeatherServiceCell.h"

@implementation MWWeatherServiceCell

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
    [_logoImageView release];
    [_nameLabel release];
    [_useSwitch release];
    [super dealloc];
}
- (IBAction)useSwitchPressed:(id)sender {
    [self.delegate weatherServiceCell:self useSwitchDidChangeStatusTo:self.useSwitch.on];
}
@end
