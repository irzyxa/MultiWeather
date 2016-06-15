//
//  MWWeatherViewController.m
//  MultiWeather
//
//  Created by AIrza on 6/13/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWWeatherViewController.h"
#import "MWProgressHUD.h"
#import "MWForecastCell.h"
#import "MWDailyForecast.h"
#import "NSDate+Helper.h"
#import "MWWeatherAPIClient.h"
#import "MWConstants.h"
#import "MWWeatherUndergroundWeather.h"
#import "MWOpenWeatherMapWeather.h"
#import "MWWorldWeatherOnlineWeather.h"
#import "MWForecastIOWeather.h"
#import "MWYahooWeather.h"
#import "NSNotificationCenter+Helper.h"
#import "UIAlertView+Helper.h"

@interface MWWeatherViewController ()

@property(nonatomic, retain) NSDateFormatter *dayFormatter;
@property(nonatomic, retain) NSDateFormatter *dateFormatter;
@property(nonatomic, retain) NSDateFormatter *timeFormatter;

@end

@implementation MWWeatherViewController {
    BOOL isBusy;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];

    self.dayFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [self.dayFormatter setDateFormat:@"EEE"];
    [self.dayFormatter setLocale:locale];
    
    self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [self.dateFormatter setDateFormat:@"dd MMMM, EEE"];
    [self.dateFormatter setLocale:locale];
    
    self.timeFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [self.timeFormatter setDateFormat:@"HH:mm:ss"];
    [self.timeFormatter setLocale:locale];
    
    isBusy = NO;
    
    [[NSNotificationCenter defaultCenter] addUniqueObserver:self selector:@selector(reloadWeather) name:MW_NOTIFICATION_UPDATE_WEATHER object:nil];
    
    UINib *nibCell = [UINib nibWithNibName:@"MWForecastCell" bundle:nil];
    [self.dailyForecastCollectionView registerNib:nibCell forCellWithReuseIdentifier:@"ForecastCell"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.serviceNameLabel.text = self.weather.serviceName;
    self.serviceLogoImageView.image = [UIImage imageNamed:self.weather.serviceLogoImageName];
    [self refreshWeather:NO];
    [self updateWeatherUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MW_NOTIFICATION_UPDATE_WEATHER object:nil];
    [_dayFormatter release];
    [_dateFormatter release];
    [_timeFormatter release];
    [_serviceNameLabel release];
    [_tempLabel release];
    [_weatherImageView release];
    [_serviceLogoImageView release];
    [_humidityLabel release];
    [_windSpeedLabel release];
    [_dateLabel release];
    [_timeLabel release];
    [_dailyForecastCollectionView release];
    [_errorLabel release];
    [super dealloc];
}

#pragma mark - Advanced methods

-(void)setIsBusy: (BOOL) busy
{
    if (busy) {
        isBusy = YES;
        [self hideWeatherUI];
        
        MWProgressHUD *hud = [MWProgressHUD showHUDForView:self.view];
        hud.title = _weather.serviceName;
    } else {
        [MWProgressHUD hideHUDForView:self.view];
        isBusy = NO;
        [self updateWeatherUI];
        [self showWeatherUI];
    }
}

-(void)errorLoading: (NSError *)error
{
    [MWProgressHUD hideHUDForView:self.view];
    isBusy = NO;
    self.errorLabel.text = [NSString stringWithFormat:@"Error! %@", error.localizedDescription];
    self.errorLabel.hidden = NO;
}

-(void)reloadWeather
{
    if ([[NSDate date] timeIntervalSinceDate:_weather.lastUpdateDateTime] / 60 > 1) {
        [self refreshWeather:YES];
    }
//    else {
//        [UIAlertView showAlertViewWithCustomErrorMessage:@"You can update weather only 1 for minute" title:@"Warning"];
//    }
}

-(void)refreshWeather:(BOOL)forced
{
    if ((_weather.dailyForecast.count == 0 || forced) && !isBusy)
    {
        MWWeatherAPIClient *client = [[[MWWeatherAPIClient alloc] init] autorelease];
        [self setIsBusy:YES];
        
        if ([_weather isKindOfClass:[MWOpenWeatherMapWeather class]]) {
            [client fetchWeatherForOpenWeatherMapWithLocation:self.location success:^(MWCustomWeather *weather) {
                self.weather = weather;
                [self setIsBusy:NO];
                NSDictionary *dataDict = [NSDictionary dictionaryWithObject:[weather retain] forKey:MW_WEATHER];
                [[NSNotificationCenter defaultCenter] postNotificationName:MW_NOTIFICATION_LOADING_COMPLITE object:self userInfo:dataDict];
            } failure:^(NSError *error) {
                [self errorLoading:error];
            }];
            
        } else if ([_weather isKindOfClass:[MWWorldWeatherOnlineWeather class]]) {
            [client fetchWeatherForWorldWeatherOnlineWithLocation:self.location success:^(MWCustomWeather *weather) {
                self.weather = weather;
                [self setIsBusy:NO];
                NSDictionary *dataDict = [NSDictionary dictionaryWithObject:[weather retain] forKey:MW_WEATHER];
                [[NSNotificationCenter defaultCenter] postNotificationName:MW_NOTIFICATION_LOADING_COMPLITE object:self userInfo:dataDict];
            } failure:^(NSError *error) {
                [self errorLoading:error];
            }];
        } else if ([_weather isKindOfClass:[MWWeatherUndergroundWeather class]]) {
            [client fetchWeatherForWeatherUndergroundWithLocation:self.location success:^(MWCustomWeather *weather) {
                self.weather = weather;
                [self setIsBusy:NO];
                NSDictionary *dataDict = [NSDictionary dictionaryWithObject:[weather retain] forKey:MW_WEATHER];
                [[NSNotificationCenter defaultCenter] postNotificationName:MW_NOTIFICATION_LOADING_COMPLITE object:self userInfo:dataDict];
            } failure:^(NSError *error) {
                [self errorLoading:error];
            }];
        } else if ([_weather isKindOfClass:[MWForecastIOWeather class]]) {
            [client fetchWeatherForForecastIOWithLocation:self.location success:^(MWCustomWeather *weather) {
                self.weather = weather;
                [self setIsBusy:NO];
                NSDictionary *dataDict = [NSDictionary dictionaryWithObject:[weather retain] forKey:MW_WEATHER];
                [[NSNotificationCenter defaultCenter] postNotificationName:MW_NOTIFICATION_LOADING_COMPLITE object:self userInfo:dataDict];
            } failure:^(NSError *error) {
                [self errorLoading:error];
            }];
        } else if ([_weather isKindOfClass:[MWYahooWeather class]]) {
            [client fetchWeatherForYahooWithLocation:self.location success:^(MWCustomWeather *weather) {
                self.weather = weather;
                [self setIsBusy:NO];
                NSDictionary *dataDict = [NSDictionary dictionaryWithObject:[weather retain] forKey:MW_WEATHER];
                [[NSNotificationCenter defaultCenter] postNotificationName:MW_NOTIFICATION_LOADING_COMPLITE object:self userInfo:dataDict];
            } failure:^(NSError *error) {
                [self errorLoading:error];
            }];
        }
    }
}

- (void)hideWeatherUI
{
    self.errorLabel.hidden = YES; //Should be always hiden

    self.tempLabel.hidden = YES;
    self.timeLabel.hidden = YES;
    self.dateLabel.hidden = YES;
    self.humidityLabel.hidden = YES;
    self.humidityImageView.hidden = YES;
    self.windImageView.hidden = YES;
    self.windSpeedLabel.hidden = YES;
    self.weatherImageView.hidden = YES;
    self.dailyForecastCollectionView.hidden = YES;
}

- (void)showWeatherUI
{
    self.tempLabel.hidden = NO;
    self.timeLabel.hidden = NO;
    self.dateLabel.hidden = NO;
    self.humidityLabel.hidden = NO;
    self.humidityImageView.hidden = NO;
    self.windImageView.hidden = NO;
    self.windSpeedLabel.hidden = NO;
    self.weatherImageView.hidden = NO;
    self.dailyForecastCollectionView.hidden = NO;
}

- (void)updateWeatherUI
{
    self.timeLabel.text = [NSString stringWithFormat:@"Last update: %@", [self.timeFormatter stringFromDate:self.weather.lastUpdateDateTime]];

    MWCondition *condition = self.weather.currentCondition;

    self.dateLabel.text = [[self.dateFormatter stringFromDate:condition.date] uppercaseString];
    
    if ([condition.temperature floatValue] <= 0)
        self.tempLabel.text = [NSString stringWithFormat:@"%d", [condition.temperature intValue]];
    else
        self.tempLabel.text = [NSString stringWithFormat:@"+%d", [condition.temperature intValue]];
    
    if (condition.imageName)
        self.weatherImageView.image = [UIImage imageNamed:condition.imageName];
    else
        self.weatherImageView.image = nil;
    
    self.humidityLabel.text = [NSString stringWithFormat:@"%d %%", [condition.humidity intValue]];
    self.windSpeedLabel.text = [NSString stringWithFormat:@"%d km/h", [condition.windSpeed intValue]];
    
    [self.dailyForecastCollectionView reloadData];
}

#pragma mark - UICollection delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.weather.dailyForecast.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = MIN(self.view.bounds.size.width / self.weather.dailyForecast.count, 108.0f);
    return CGSizeMake(width, self.dailyForecastCollectionView.bounds.size.height);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MWForecastCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ForecastCell" forIndexPath:indexPath];
    
    MWDailyForecast *forecast = self.weather.dailyForecast[indexPath.row];
    
    if (forecast.imageName)
        cell.weatherImageView.image = [UIImage imageNamed:forecast.imageName];
    else
        cell.weatherImageView.image = nil;

    if ([forecast.tempMax floatValue] <= 0)
        cell.tempMaxLabel.text = [NSString stringWithFormat:@"%d", [forecast.tempMax intValue]];
    else
        cell.tempMaxLabel.text = [NSString stringWithFormat:@"+%d", [forecast.tempMax intValue]];
    if ([forecast.tempMin floatValue] <= 0)
        cell.tempMinLabel.text = [NSString stringWithFormat:@"%d", [forecast.tempMin intValue]];
    else
        cell.tempMinLabel.text = [NSString stringWithFormat:@"+%d", [forecast.tempMin intValue]];

    if ([forecast.date isSameDay:[NSDate date]])
        cell.dayLabel.text = @"Today";
    else
        cell.dayLabel.text = [self.dayFormatter stringFromDate:forecast.date];
    
    return cell;
}

@end
