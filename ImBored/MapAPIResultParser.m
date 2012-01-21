//
//  MapAPIResultParser.m
//  ImBored
//
//  Created by Amy Dyer on 1/21/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "MapAPIResultParser.h"
#import <CoreLocation/CoreLocation.h>

#define STATUS_OK 1;
#define STATUS_BAD 0;


@implementation Result
@synthesize latitude, longitude, name, address, type;

- (id) init {
    self = [super init];
    if (self) {
        latitude = [[NSMutableString alloc] init];
        longitude = [[NSMutableString alloc] init];
        name = [[NSMutableString alloc] init];
        address = [[NSMutableString alloc] init];
        type = [[NSMutableString alloc] init];
    }
    return self;
}

- (CLLocationCoordinate2D) coordinate {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    NSNumber * latNumber = [f numberFromString:latitude];
    NSNumber * longNumber = [f numberFromString:longitude];
    
    CLLocationDegrees lat = [latNumber doubleValue];
    CLLocationDegrees lng = [longNumber doubleValue];
    
    [f release];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
    return coordinate;
}

- (void) setTitle:(NSString *)title {
}
- (void) setSubtitle:(NSString *)subtitle {
}

- (NSString *) title {
    return [NSString stringWithString:name];
}

- (NSString *) subtitle {
    return [NSString stringWithString:address];
}

- (void) dealloc{
    [latitude release];
    [longitude release];
    [name release];
    [address release];
    [type release];
    
    [super dealloc];
}

@end


@implementation MapAPIResultParser
@synthesize result, element;

/* 
 <status>OK</status>
 <result>
 <name>Zaaffran Restaurant - BBQ and GRILL, Darling Harbour</name>
 <vicinity>Harbourside Centre 10 Darling Drive, Darling Harbour, Sydney</vicinity>
 <type>restaurant</type>
 <type>food</type>
 <type>establishment</type>
 <geometry>
 <location>
 <lat>-33.8719830</lat>
 <lng>151.1990860</lng>
 </location>
 </geometry>
 </result>
*/

- (void) dealloc {
    [failBlock release];
    [doneBlock release];
    
    [super dealloc];
}

- (void) parseResults:(NSString *)_result onComplete:(ParseCompleteBlock)completeBlock onFail:(FailBlock)_failBlock{
    doneBlock = [completeBlock copy];
    failBlock = [_failBlock copy];
    
    resultArray = [[NSMutableArray alloc] init];

    _parser = [[NSXMLParser alloc] initWithData:[_result dataUsingEncoding:NSUTF8StringEncoding]];
    _parser.delegate = self;
    [_parser parse];
}

BOOL parseGeometry = NO;

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    self.element = elementName;
    
    if ([self.element isEqualToString:@"result"]) {
        self.result = [[[Result alloc] init] autorelease];
    }
    
    else if ([self.element isEqualToString:@"location"]) {
        parseGeometry = YES;
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([self.element isEqualToString:@"status"]) {
        if ([string isEqualToString:@"OK"] == NO) {
            [parser abortParsing];
            failBlock();
        }
    }
    
    else if ([self.element isEqualToString:@"name"]) {
        [self.result.name appendString:string];
    }
    
    else if ([self.element isEqualToString:@"vicinity"]) {
        [self.result.address appendString:string];
    }
    
    else if ([self.element isEqualToString:@"lat"] && parseGeometry) {
        [self.result.latitude appendString:string];
    }
    
    else if ([self.element isEqualToString:@"lng"] && parseGeometry) {
        [self.result.longitude appendString:string];
    }
    
    else if ([self.element isEqualToString:@"type"]) {
        [self.result.type appendString:string];
    }
}


- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"result"]) {
        
        [resultArray addObject:self.result];
        self.result = nil;
    }
    
    else if ([elementName isEqualToString:@"location"]) {
        parseGeometry = NO;
    }
    
    self.element = nil;

}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
    if ([resultArray count] > 0) {
        doneBlock([resultArray copy]);
    } else {
        failBlock();
    }
}


@end
