//
//  Location.m
//  ImBored
//
//  Created by Amy Dyer on 1/22/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "Quest.h"

@implementation Quest
@synthesize latitude, longitude, name, address, types, title, subtitle, coordinate, listings;

- (id) init {
    self = [super init];
    if (self) {
        latitude = [[NSMutableString alloc] init];
        longitude = [[NSMutableString alloc] init];
        name = [[NSMutableString alloc] init];
        address = [[NSMutableString alloc] init];
        types = [[NSMutableArray alloc] init];
        listings = [[NSMutableString alloc] init];
    }
    return self;
}

- (void) dealloc{
    [title release];
    [subtitle release];
    [latitude release];
    [longitude release];
    [name release];
    [address release];
    [types release];
    [listings release];
    [verb release];
    
    [super dealloc];
}

- (CLLocationCoordinate2D) coordinate {
    if (coordinate.latitude !=  0 && coordinate.longitude != 0) {
        return coordinate;
    } else {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        NSNumber * latNumber = [f numberFromString:latitude];
        NSNumber * longNumber = [f numberFromString:longitude];
        
        CLLocationDegrees lat = [latNumber doubleValue];
        CLLocationDegrees lng = [longNumber doubleValue];
        
        [f release];
        
        CLLocationCoordinate2D newCoordinate = CLLocationCoordinate2DMake(lat, lng);
        return newCoordinate;
    }
}

- (NSString *) title {
    if (!title) {
        return [NSString stringWithString:name];
    } else return title;
}

- (NSString *) subtitle {
    if (!subtitle) {
        return [NSString stringWithString:address];
    } else return subtitle;
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
    if (verb) return verb;
    
    
    verb = [UtilityKit randomItem:@"visit", @"see", @"go to", nil];
    for (NSString * type in types) {
        NSString * newVerb = [self verbForType:type];
        if (newVerb) {
            verb = newVerb;
            break;
        }
    }
    
    [verb retain];    
    return verb;
}

@end
