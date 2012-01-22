//
//  Location.m
//  ImBored
//
//  Created by Amy Dyer on 1/22/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "Location.h"

@implementation Location
@synthesize latitude, longitude, name, address, type, title, subtitle, coordinate;

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

- (void) dealloc{
    [title release];
    [subtitle release];
    [latitude release];
    [longitude release];
    [name release];
    [address release];
    [type release];
    
    [super dealloc];
}

@end
