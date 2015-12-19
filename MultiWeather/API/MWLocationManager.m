//
//  MWLocationsManager.m
//  MultiWeather
//
//  Created by AIrza on 12/06/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWLocationManager.h"
#import "MWLocation.h"

static NSString *cMWLocationsSearchURL = @"http://api.geonames.org/searchJSON?name_startsWith=%@&featureClass=P&maxRows=%d&startRow=%d&lang=%@&isNameRequired=true&username=irzyxa";

static NSString *cMWLocationsResultKey = @"geonames";

@interface MWLocationManager ()

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *bufData;

@end

@implementation MWLocationManager


-(void)search:(NSString *)query maxRows:(NSInteger)maxRows
{
    NSString *escQuery = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:cMWLocationsSearchURL, escQuery, maxRows, 0, @"en"];
    [self sendRequestWithURLString:urlString];
}

- (void)sendRequestWithURLString:(NSString *)urlString
{
    self.bufData = [NSMutableData data];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

-(void)cancelConnection
{
    [self.connection cancel];
    self.bufData = nil;
    self.connection = nil;
}

-(void)parseEnded: (NSDictionary *)result
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(locationManager:didFinishWithLocations:)]) {
        NSArray *locations = [result objectForKey:cMWLocationsResultKey];
        
        NSMutableArray *res = [[NSMutableArray alloc] init];
        
        for (NSDictionary *place in locations) {
            [res addObject: [MWLocation locationFromDictionary:place]];
        }
        
        [self.delegate locationManager:self didFinishWithLocations:[res autorelease]];
    }
}

#pragma mark - NSURLConectionDelegate

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.bufData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:self.bufData options:NSJSONReadingMutableContainers error:&error];
    
    if (resultDict) {
        
        NSDictionary *locations = [resultDict objectForKey:cMWLocationsResultKey];
        NSLog(@"%@", locations);
        
        if (locations) {
            [self parseEnded:resultDict];
        }
        
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.bufData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(locationManager:didFinishWithError:)]) {
        [self.delegate locationManager:self didFinishWithError:error];
    }
}

-(void)dealloc
{
    [_connection release];
    [_bufData release];
    [super dealloc];
}

@end
