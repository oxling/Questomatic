//
//  MapAPIResultParser.m
//  ImBored
//
//  Created by Amy Dyer on 1/21/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import "MapAPIResultParser.h"
#import <CoreLocation/CoreLocation.h>

@interface MapAPIResultParser ()  {}

- (NSArray *) parseJSONObject:(NSData *)data;

@end

@implementation MapAPIResultParser

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

- (NSString * ) processListingsHTML:(NSString *)listing {
    
    if (listing == nil)
        return nil;
    
    NSMutableString * str = [NSMutableString stringWithString:listing];
    [str replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"&gt;" withString:@">" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str length])];
    
    [str insertString:@"<html><body><font size=\"12\" color=white>" atIndex:0];
    [str insertString:@"</font></body></html>" atIndex:[str length]];

    return str;
}

- (NSArray *) parseJSONObject:(NSData *)data {
    NSMutableArray * quests = [[[NSMutableArray alloc] init] autorelease];
   
    NSArray * results = [data valueForKey:@"results"];
    for (NSDictionary * d in results) {
        Quest * q = [[Quest alloc] init];
        
        q.name = [d objectForKey:@"name"];
        q.types = [d objectForKey:@"types"];
        double lat = [[d valueForKeyPath:@"geometry.location.lat"] doubleValue];
        double lng = [[d valueForKeyPath:@"geometry.location.lng"] doubleValue];
        q.coordinate = CLLocationCoordinate2DMake(lat, lng);
        q.iconURL = [d objectForKey:@"icon"];
        q.types = [d objectForKey:@"types"];
        q.address = [d objectForKey:@"vicinity"];
        q.reference = [d objectForKey:@"reference"];
        q.listings = [self processListingsHTML:[d objectForKey:@"html_attribution"]];
        
        [quests addObject:q];
        
        [q release];
    }
    
    return [NSArray arrayWithArray:quests];
}

- (NSArray *) parseLocationResults:(NSData *)data {    

    NSError * error = nil;
    id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!jsonData || error) {
        DebugLog(@"Error parsing data: %@", [error localizedDescription]);
    } else {
        return [self parseJSONObject:jsonData];
    }
    
    return nil;
}

@end
