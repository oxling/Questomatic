//
//  MapAPIResultParser.m
//  ImBored
//
//  Created by Amy Dyer on 1/21/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "MapAPIResultParser.h"
#import <CoreLocation/CoreLocation.h>

@interface MapAPIResultParser ()  {
@private
    BOOL parseGeometry;
    NSMutableString * typeString;

}
@property (nonatomic, retain)  NSMutableString * typeString;

@end

@implementation MapAPIResultParser
@synthesize result, element, typeString;

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
    [result release];
    [element release];
    [typeString release];
    
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

- (NSArray *) parseResults:(NSData *)data {    
    resultArray = [[NSMutableArray array] retain];

    NSXMLParser * parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
   
    [parser parse];
    [parser release];
    
    NSArray * finalResults = [NSArray arrayWithArray:resultArray];
    
    [resultArray release];
    resultArray = nil;
    
    return finalResults;
    
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    self.element = elementName;
    
    if ([self.element isEqualToString:@"result"]) {
        self.result = [[[Quest alloc] init] autorelease];
    }
    
    else if ([self.element isEqualToString:@"location"]) {
        parseGeometry = YES;
    }
    
    else if ([self.element isEqualToString:@"type"]) {
        self.typeString = [NSMutableString string];
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([self.element isEqualToString:@"status"]) {
        if ([string isEqualToString:@"OK"] == NO) {
            [parser abortParsing];
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
        [typeString appendString:string];
    }
    
    else if ([self.element isEqualToString:@"html_attribution"]) {
        NSString * normalString = [self processListingsHTML:string];
        [self.result.listings appendString:normalString];
    }
}


- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"result"]) {
        
        if ([self.result.listings length] > 0) {
            DebugLog(@"Result %@ has listings: %@", self.result, self.result.listings);
        }
        
        [resultArray addObject:self.result];
        self.result = nil;
    }
    
    else if ([elementName isEqualToString:@"location"]) {
        parseGeometry = NO;
    }
    
    else if ([elementName isEqualToString:@"type"]) {
        [self.result.types addObject:[NSString stringWithString:typeString]];
        self.typeString = nil;
    }
    
    self.element = nil;

}

@end
