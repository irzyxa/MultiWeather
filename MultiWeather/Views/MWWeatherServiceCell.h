//
//  MWWeatherServiceCell.h
//  MultiWeather
//
//  Created by AIrza on 20/06/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MWWeatherServiceCell;

@protocol MWWeatherServiceDelegate <NSObject>

- (void)weatherServiceCell: (MWWeatherServiceCell *)cell useSwitchDidChangeStatusTo:(BOOL) status;

@end

@interface MWWeatherServiceCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *logoImageView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UISwitch *useSwitch;
@property (assign, nonatomic) id<MWWeatherServiceDelegate> delegate;

- (IBAction)useSwitchPressed:(id)sender;

@end
