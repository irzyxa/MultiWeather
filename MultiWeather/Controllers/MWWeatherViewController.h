//
//  MWWeatherViewController.h
//  MultiWeather
//
//  Created by AIrza on 6/13/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWCustomWeather.h"

@interface MWWeatherViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property NSUInteger pageIndex;
@property (nonatomic, retain) MWCustomWeather *weather;
@property (nonatomic, retain) MWLocation *location;
@property (retain, nonatomic) IBOutlet UILabel *errorLabel;
@property (retain, nonatomic) IBOutlet UILabel *serviceNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *tempLabel;
@property (retain, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (retain, nonatomic) IBOutlet UIImageView *serviceLogoImageView;
@property (retain, nonatomic) IBOutlet UILabel *humidityLabel;
@property (retain, nonatomic) IBOutlet UIImageView *humidityImageView;
@property (retain, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (retain, nonatomic) IBOutlet UIImageView *windImageView;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UICollectionView *dailyForecastCollectionView;

@end
