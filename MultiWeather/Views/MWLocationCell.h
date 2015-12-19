//
//  MWLocationCell.h
//  MultiWeather
//
//  Created by AIrza on 6/6/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWLocationCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *cityLabel;
@property (retain, nonatomic) IBOutlet UILabel *regionLabel;
@property (retain, nonatomic) IBOutlet UIImageView *cityImageView;

@end
