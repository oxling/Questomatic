//
//  Location.m
//  ImBored
//
//  Created by Amy Dyer on 1/22/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import "Quest.h"

@implementation Quest
@synthesize coordinate = _coordinate, title = _title, subtitle = _subtitle;
@synthesize name = _name, address = _address, types = _types, listings = _listings, iconURL = _iconURL, reference = _reference;
@synthesize websiteURL = _websiteURL;

- (void) dealloc{
    [_title release];
    [_subtitle release];
    [_name release];
    [_address release];
    [_types release];
    [_listings release];
    [_iconURL release];
    [_reference release];
    [_verb release];
    [_websiteURL release];
    
    [super dealloc];
}

- (NSString *) title {
    if (!_title) {
        return _name;
    } else {
        return _title;
    }
}

- (NSString *) subtitle {
    if (!_subtitle) {
        return _address;
    } else {
        return _subtitle;
    }
}

- (NSString *) verbForType:(NSString *)type {
    
    if ([type isEqualToString:@"grocery_or_supermarket"]) {
        return @"buy a snack at";
    }
    
    if ([type isEqualToString:@"cafe"]) {
        return @"drink coffee at";
    }
    
    if ([type isEqualToString:@"restaurant"] ||
        [type isEqualToString:@"bakery"]) {
        
        return @"eat at";
    }
    
    if ([type isEqualToString:@"library"]) {
        return @"read a book at";
    }
    
    if ([type isEqualToString:@"bar"] ||
        [type isEqualToString:@"night_club"]) {
        return [UtilityKit randomItem:@"drink at", @"dance at", nil];
    }
    
    if ([type isEqualToString:@"store"]) {
        return [UtilityKit randomItem:@"shop at", @"buy something at", nil];
    }
    
    if ([type isEqualToString:@"gym"]) {
        return @"work out at";
    }
    
    if ([type isEqualToString:@"salon"]) {
        return [UtilityKit randomItem:@"get a haircut at", @"dye your hair at", nil];
    }
    
    if ([type isEqualToString:@"movie_theater"]) {
        return @"see a movie at";
    }
    
    if ([type isEqualToString:@"natural_feature"] ||
        [type isEqualToString:@"point_of_interest"]) {
        return [UtilityKit randomItem:@"see", @"take a picture of", @"admire", nil];
    }
    
    if ([type isEqualToString:@"water"]) {
        return [UtilityKit randomItem:@"swim in the", @"sail on the", @"fish in the", @"drink from the", nil];
    }
    
    if ([type isEqualToString:@"spa"]) {
        return @"relax at";
    }
    
    else return nil;
}

- (NSString *) getVerb {
    if (_verb) 
        return _verb;
    
    
    _verb = [UtilityKit randomItem:@"visit", @"see", @"go to", nil];
    for (NSString * type in _types) {
        NSString * newVerb = [self verbForType:type];
        if (newVerb) {
            _verb = newVerb;
            break;
        }
    }
    
    [_verb retain];    
    return _verb;
}

- (NSURL *) getLink {
    CLLocationCoordinate2D coord = self.coordinate;
    NSString * urlStr = [NSString stringWithFormat:@"https://maps.google.com/maps?ll=%f,%f", coord.latitude, coord.longitude];
    return [NSURL URLWithString:urlStr];
}

@end
