//
//  MWForecastCell.h
//  MultiWeather
//
//  Created by AIrza on 7/2/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWForecastCell : UICollectionViewCell
@property (retain, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (retain, nonatomic) IBOutlet UILabel *tempMaxLabel;
@property (retain, nonatomic) IBOutlet UILabel *tempMinLabel;
@property (retain, nonatomic) IBOutlet UILabel *dayLabel;

@end
