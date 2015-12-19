//
//  MWLocationCell.m
//  MultiWeather
//
//  Created by AIrza on 6/6/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWLocationCell.h"

@implementation MWLocationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

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
    [_cityLabel release];
    [_cityImageView release];
    [_regionLabel release];
    [super dealloc];
}
@end
