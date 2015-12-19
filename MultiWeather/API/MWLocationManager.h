//
//  MWLocationsManager.h
//  MultiWeather
//
//  Created by AIrza on 12/06/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MWLocationManagerDelegate;

@interface MWLocationManager : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, assign) id <MWLocationManagerDelegate> delegate;

- (void)search:(NSString *)query maxRows: (NSInteger)maxRows;
- (void)cancelConnection;

@end

@protocol MWLocationManagerDelegate <NSObject>

@optional

-(void)locationManager: (MWLocationManager *)handler didFinishWithLocations:(NSArray *)locations;
-(void)locationManager:(MWLocationManager *)handler didFinishWithError:(NSError *)error;

@end
