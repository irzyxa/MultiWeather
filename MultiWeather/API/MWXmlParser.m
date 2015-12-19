//
//  MWXmlParser.m
//  MultiWeather
//
//  Created by AIrza on 7/3/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWXmlParser.h"

@interface MWXmlParser()


-(id)initWithError:(NSError**)error;
-(NSDictionary *)objectWithData:(NSData *)data;

@end

@implementation MWXmlParser
{
    NSMutableArray *dictStack;
    NSMutableString *currentElement;
    NSError **errorPointer;
}

+(NSDictionary *)dictionaryForXmlData:(NSData *)data error:(NSError **)errorPointer
{
    MWXmlParser *parser = [[MWXmlParser alloc] init];
    
    NSDictionary *res = [parser objectWithData:data];
    
    [parser release];
    
    return res;
}

-(id)initWithError:(NSError **)error
{
    if (self = [super init]) {
        errorPointer = error;
    }
    return self;
}

-(void)dealloc
{
    [dictStack release];
    [currentElement release];
    [super dealloc];
}

-(NSDictionary *)objectWithData:(NSData *)data
{
    [dictStack release];
    [currentElement release];

    dictStack = [[NSMutableArray alloc] init];
    currentElement = [[NSMutableString alloc] init];
    
    [dictStack addObject:[NSMutableDictionary dictionary]];
    
    NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:data] autorelease];
    parser.delegate = self;
    
    BOOL success = [parser parse];
    
    if (success) {
        NSDictionary *res = [dictStack objectAtIndex:0];
        return res;
    }
    
    return nil;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSMutableDictionary *parentDict = [dictStack lastObject];
    NSMutableDictionary *childDict = [NSMutableDictionary dictionary];
    
    [childDict addEntriesFromDictionary:attributeDict];
    id existingValue = [parentDict objectForKey:elementName];
    
    if (existingValue) {
        NSMutableArray *array = nil;
        if ([existingValue isKindOfClass:[NSMutableArray class]]) {
            array = (NSMutableArray *)existingValue;
        } else {
            array = [NSMutableArray array];
            [array addObject:existingValue];
            [parentDict setObject:array forKey:elementName];
        }
        
        [array addObject:childDict];
    } else {
        [parentDict setObject:childDict forKey:elementName];
    }
    
    [dictStack addObject:childDict];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSMutableDictionary *dictValue = [dictStack lastObject];
    
    if ([currentElement length] > 0) {
        [dictValue setObject:currentElement forKey:@"text"];
        [currentElement release];
        currentElement = [[NSMutableString alloc] init];
    }
    
    [dictStack removeLastObject];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentElement appendString:string];
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    *errorPointer = parseError;
}

@end
