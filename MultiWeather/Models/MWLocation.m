//
//  MWLocation.m
//  MultiWeather
//
//  Created by AIrza on 6/6/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWLocation.h"

@implementation MWLocation

-(id)init
{
    if (self = [super init]) {
        self.cityName = @"Unknown";
        self.adminName = @"Unknown";
        self.countryName = @"";
        self.countryCode = @"";
        self.longitude = @0;
        self.latitude = @0;
    }
    
    return self;
}

-(id)initWithDictionary:(NSDictionary *)data
{
    if (self = [super init]) {
        self.cityName = data[@"name"];
        self.adminName = data[@"adminName1"];
        self.countryName = data[@"countryName"];
        self.countryCode = data[@"countryCode"];
        self.longitude = data[@"lng"];
        self.latitude = data[@"lat"];
    }
    
    return self;
}

-(void)dealloc
{
    [_cityName release];
    [_adminName release];
    [_countryName release];
    [_countryCode release];
    [_latitude release];
    [_longitude release];
    [super dealloc];
}

+(id)locationFromDictionary:(NSDictionary *)data
{
    return [[[self alloc] initWithDictionary:data] autorelease];
}

-(NSString *)regionName
{
    if ([self.adminName isEqualToString:@""]) {
        return self.countryName;
    } else if ([self.countryName isEqualToString:@""]) {
        return self.adminName;
    } else {
        return [NSString stringWithFormat:@"%@, %@", self.adminName, self.countryName];
    }
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.cityName forKey:@"cityName"];
    [aCoder encodeObject:self.adminName forKey:@"adminName"];
    [aCoder encodeObject:self.countryName forKey:@"countryName"];
    [aCoder encodeObject:self.countryCode forKey:@"countryCode"];
    [aCoder encodeObject:self.latitude forKey:@"latitude"];
    [aCoder encodeObject:self.longitude forKey:@"longitude"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.cityName = [aDecoder decodeObjectForKey:@"cityName"];
        self.adminName = [aDecoder decodeObjectForKey:@"adminName"];
        self.countryName = [aDecoder decodeObjectForKey:@"countryName"];
        self.countryCode = [aDecoder decodeObjectForKey:@"countryCode"];
        self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
        self.longitude = [aDecoder decodeObjectForKey:@"longitude"];
    }
    
    return self;
}

@end
