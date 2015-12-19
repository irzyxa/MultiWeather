//
//  MWXmlParser.h
//  MultiWeather
//
//  Created by AIrza on 7/3/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWXmlParser : NSObject<NSXMLParserDelegate>

+ (NSDictionary *)dictionaryForXmlData:(NSData *)data error:(NSError**)errorPointer;

@end
