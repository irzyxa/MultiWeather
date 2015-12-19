//
//  MWWeatherPageViewController.m
//  MultiWeather
//
//  Created by AIrza on 6/13/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWWeatherPageViewController.h"
#import "MWWeatherViewController.h"
#import "MWSettings.h"
#import "MWWeatherUndergroundWeather.h"
#import "MWOpenWeatherMapWeather.h"
#import "MWWorldWeatherOnlineWeather.h"
#import "MWForecastIOWeather.h"
#import "MWYahooWeather.h"
#import "MWWeatherAPIClient.h"
#import "MWProgressHUD.h"

@interface MWWeatherPageViewController () {
}

@property (nonatomic, retain) NSMutableArray *pageContent;

@end

@implementation MWWeatherPageViewController

-(NSMutableArray *)pageContent
{
    if (!_pageContent) {
        _pageContent = [[NSMutableArray alloc] init];
    }
    return _pageContent;
}

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@, %@", self.location.cityName, self.location.countryCode];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updeteItems:) name:MW_NOTIFICATION_LOADING_COMPLITE object:nil];
    
    [self fillPageContent];
   
    // Create page view controller
    if (self.pageContent.count > 0) {
        self.servicesNotFoundLabel.hidden = YES;

        self.weatherPageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WeatherPageViewController"];
        self.weatherPageViewController.dataSource = self;
        
        MWWeatherViewController *startingViewController = [self viewControllerAtIndex:0];
        NSArray *viewControllers = @[startingViewController];
        [self.weatherPageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        // Change the size of page view controller
        self.weatherPageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [self addChildViewController:self.weatherPageViewController];
        [self.view addSubview:self.weatherPageViewController.view];
        [self.weatherPageViewController didMoveToParentViewController:self];
    } else {
        self.servicesNotFoundLabel.hidden = NO;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MW_NOTIFICATION_LOADING_COMPLITE object:nil];
    [_backgroundImageView release];
    [_servicesNotFoundLabel release];
    [_pageContent release];
    [_weatherPageViewController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPageViewController datasource

- (MWWeatherViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if ((self.pageContent.count == 0) || (index > self.pageContent.count)) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    MWWeatherViewController *weatherViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"WeatherViewController"];
    weatherViewController.weather = self.pageContent[index];
    weatherViewController.location = self.location;
    weatherViewController.pageIndex = index;
    return weatherViewController;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((MWWeatherViewController *) viewController).pageIndex;
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == self.pageContent.count) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = ((MWWeatherViewController *) viewController).pageIndex;
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.pageContent.count;
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - Advanced methods

-(void)updeteItems: (NSNotification *)notification
{
    NSDictionary *data = [notification userInfo];
    
    MWCustomWeather *weather = [data objectForKey:MW_WEATHER];
    
    for (int i = 0; i < self.pageContent.count; i++) {
        if ([self.pageContent[i] isKindOfClass: [weather class]]) {
            [self.pageContent replaceObjectAtIndex:i withObject: weather];
        }
    }
}

-(void)fillPageContent
{
 	// Create the data model
    NSArray *items = [MWSettings getWeatherServices];
    
    for (NSDictionary *item in items) {
        if ([item[MW_SERVICE_USE] boolValue]) {
            
            if ([item[MW_SERVICE_NAME] isEqualToString:MW_WEATHER_SERVISE_OWM]) {
                [self.pageContent addObject:[[[MWOpenWeatherMapWeather alloc] init] autorelease]];
            }
            
            if ([item[MW_SERVICE_NAME] isEqualToString:MW_WEATHER_SERVISE_WWO]) {
                [self.pageContent addObject:[[[MWWorldWeatherOnlineWeather alloc] init] autorelease]];
            }
            
            if ([item[MW_SERVICE_NAME] isEqualToString:MW_WEATHER_SERVISE_WU]) {
                [self.pageContent addObject:[[[MWWeatherUndergroundWeather alloc] init] autorelease]];
            }
            if ([item[MW_SERVICE_NAME] isEqualToString:MW_WEATHER_SERVISE_FIO]) {
                [self.pageContent addObject:[[[MWForecastIOWeather alloc] init] autorelease]];
            }
            if ([item[MW_SERVICE_NAME] isEqualToString:MW_WEATHER_SERVISE_YAHOO]) {
                [self.pageContent addObject:[[[MWYahooWeather alloc] init] autorelease]];
            }
        }
    }
}

#pragma mark - Actions

- (IBAction)refreshPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:MW_NOTIFICATION_UPDATE_WEATHER object:self userInfo:nil];
}

@end
