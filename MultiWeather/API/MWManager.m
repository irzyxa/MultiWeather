//
//  MWManager.m
//  MultiWeather
//
//  Created by AIrza on 6/8/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWManager.h"
#import "MWSettings.h"

@interface MWManager ()

@property (nonatomic, retain) CLLocationManager *locationManager;

@end

@implementation MWManager

-(void)setDefaultLocation:(MWLocation *)defaultLocation
{
    _defaultLocation.cityName = defaultLocation.cityName;
    _defaultLocation.adminName = defaultLocation.adminName;
    _defaultLocation.countryName = defaultLocation.countryName;
    _defaultLocation.countryCode = defaultLocation.countryCode;
    _defaultLocation.longitude = defaultLocation.longitude;
    _defaultLocation.latitude = defaultLocation.latitude;
}

+ (instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

-(id)init
{
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _defaultLocation = [[MWLocation alloc] init];
    }
    
    return self;
}

#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];

    if (location.horizontalAccuracy > 0) {
        
        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
        [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            for (CLPlacemark *placemark in placemarks) {
                _defaultLocation.cityName = placemark.locality;
                _defaultLocation.adminName = placemark.administrativeArea;
                _defaultLocation.countryName = placemark.country;
                _defaultLocation.countryCode = placemark.ISOcountryCode;
                _defaultLocation.latitude = [NSNumber numberWithFloat: placemark.location.coordinate.latitude];
                _defaultLocation.longitude = [NSNumber numberWithFloat: placemark.location.coordinate.longitude];
            }
            [MWSettings setObject:[NSKeyedArchiver archivedDataWithRootObject:_defaultLocation] forParameter:MW_SETTINGS_DEFAULT_LOCATION];
        }];
    
    [geoCoder release];

        [self.locationManager stopUpdatingLocation];
   }
}

-(void)getDefaultLocation
{
    NSData *data = [MWSettings getObjectForParameter:MW_SETTINGS_DEFAULT_LOCATION];
    if (data == nil) {
        [self.locationManager startUpdatingLocation];
    } else {
        self.defaultLocation = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

-(void)dealloc
{
    [_locationManager stopUpdatingLocation];
    [_locationManager release];
    [_defaultLocation release];
    [super dealloc];
}

#pragma mark - Save/Load locations

-(void)saveFavoritesLocations:(NSMutableArray *)locations
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:locations];
    [MWSettings setObject:data forParameter:MW_SETTINGS_FAVORITE_LOCATIONS];
}

-(NSMutableArray *)loadFavoritesLocations
{
    NSData *data = [MWSettings getObjectForParameter:MW_SETTINGS_FAVORITE_LOCATIONS];
    if (data == nil) {
        return [[[NSMutableArray alloc] init] autorelease];
    } else {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

@end
