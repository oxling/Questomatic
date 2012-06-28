//
//  MapAPIDetailParser.m
//  ImBored
//
//  Created by Amy Dyer on 4/8/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "MapAPIDetailParser.h"
#import "Quest.h"

@interface MapAPIDetailParser () {
@private
    Quest * _quest;
}
@end

@implementation MapAPIDetailParser

NSMutableString * currentString = nil;

- (void) parseDetailResults:(NSData *)data intoQuest:(Quest *)quest {
    _quest = quest;
    [self parseData:data];    
}

- (void) didFindString:(NSString *)string inElement:(NSString *)element {
    if ([element isEqualToString:@"website"]) {
        _quest.websiteURL = string;
    }
}

@end
