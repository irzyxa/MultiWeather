//
//  MWManager.h
//  MultiWeather
//
//  Created by AIrza on 6/8/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

@import CoreLocation;
#import <Foundation/Foundation.h>
#import "MWLocation.h"

@interface MWManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, retain, readwrite) MWLocation *defaultLocation;

+ (instancetype)sharedManager;

- (void)getDefaultLocation;

- (void)saveFavoritesLocations:(NSMutableArray *)locations;
- (NSMutableArray *)loadFavoritesLocations;

@end
