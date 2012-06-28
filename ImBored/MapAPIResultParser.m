//
//  MapAPIResultParser.m
//  ImBored
//
//  Created by Amy Dyer on 1/21/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import "MapAPIResultParser.h"
#import <CoreLocation/CoreLocation.h>

@interface MapAPIResultParser ()  {
@private
    BOOL parseGeometry;
    NSNumberFormatter * _coordinateFormatter;
    Quest * _result;
}
@property (nonatomic, retain) Quest * result;

@end

@implementation MapAPIResultParser
@synthesize result = _result;

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
    [resultArray release];
    [_coordinateFormatter release];
    [_result release];
    
    [super dealloc];
}

- (NSMutableString * ) processListingsHTML:(NSString *)listing {
    
    NSMutableString * str = [NSMutableString stringWithString:listing];
    [str replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"&gt;" withString:@">" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str length])];
    
    [str insertString:@"<html><body><font size=\"12\" color=white>" atIndex:0];
    [str insertString:@"</font></body></html>" atIndex:[str length]];

    return str;
}

- (NSArray *) parseLocationResults:(NSData *)data {    
    resultArray = [[NSMutableArray alloc] init];
    _coordinateFormatter = [[NSNumberFormatter alloc] init];
   
    [self parseData:data];
    
    NSArray * finalResults = [NSArray arrayWithArray:resultArray];
    
    [resultArray release];
    resultArray = nil;
    
    [_coordinateFormatter release];
    _coordinateFormatter = nil;
    
    return finalResults;
}

- (void) didStartElement:(NSString *)element {

    if ([element isEqualToString:@"result"]) {
        _result = [[Quest alloc] init];
    }
    
    else if ([element isEqualToString:@"location"]) {
        parseGeometry = YES;
    }
}

- (void) didFindString:(NSString *)string inElement:(NSString *)element {
        
    if ([element isEqualToString:@"name"]) {
        _result.name = string;
    }
    
    else if ([element isEqualToString:@"vicinity"]) {
        _result.address = string;
    }
    
    else if ([element isEqualToString:@"lat"] && parseGeometry) {
        NSNumber * latNumber = [_coordinateFormatter numberFromString:string];
        CLLocationDegrees lat = [latNumber doubleValue];
        _result.coordinate = CLLocationCoordinate2DMake(lat, _result.coordinate.longitude);
    }
    
    else if ([element isEqualToString:@"lng"] && parseGeometry) {
        NSNumber * lngNumber = [_coordinateFormatter numberFromString:string];
        CLLocationDegrees lng = [lngNumber doubleValue];
        _result.coordinate = CLLocationCoordinate2DMake(_result.coordinate.latitude, lng);
    }
    
    else if ([element isEqualToString:@"type"]) {
        [_result.types addObject:string];
    }
    
    else if ([element isEqualToString:@"html_attribution"]) {
        NSString * normalString = [self processListingsHTML:string];
        _result.listings = normalString;
    }
    
    else if ([element isEqualToString:@"icon"]) {
        _result.iconURL = string;
    }
    
    else if ([element isEqualToString:@"reference"]) {
        _result.reference = string;
    }
}

- (void) didEndElement:(NSString *)element {
    
    if ([element isEqualToString:@"result"]) {
        
        if ([self.result.listings length] > 0) {
            DebugLog(@"Result %@ has listings: %@", self.result, self.result.listings);
        }
        
        [resultArray addObject:_result];
        
        [_result release];
        _result = nil;
    }
    
    else if ([element isEqualToString:@"location"]) {
        parseGeometry = NO;
    }
}

@end
