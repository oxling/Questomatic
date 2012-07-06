//
//  MapAPIDetailParser.m
//  ImBored
//
//  Created by Amy Dyer on 4/8/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "MapAPIDetailParser.h"
#import "Quest.h"

@implementation MapAPIDetailParser

NSMutableString * currentString = nil;

- (void) parseDetailResults:(NSData *)data intoQuest:(Quest *)quest {
    NSError * error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if (!result || error) {
        DebugLog(@"Error parsing details: %@", [error localizedDescription]);
        return;
    }
    
    NSString * websiteURL = [result valueForKeyPath:@"result.website"];
    if (!websiteURL) {
        websiteURL = [result valueForKeyPath:@"result.url"];
    }
    
    quest.websiteURL = websiteURL;
}

@end
