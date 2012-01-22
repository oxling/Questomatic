//
//  LocationController.m
//  ImBored
//
//  Created by Amy Dyer on 1/22/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "LocationController.h"

@implementation LocationController
@synthesize onFoundLocation;

#pragma mark - Memory

- (id) init {
    self = [super init];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        coder = [[CLGeocoder alloc] init];
    }
    
    return self;
}

- (void) dealloc {
    [locationManager release];
    [coder release];
    [onFoundLocation release];
    
    [super dealloc];
}

#pragma mark - Location

- (void) stopUpdatingUserLocation {
    [locationManager stopUpdatingLocation];
}

- (void) startUpdatingUserLocation:(void (^)(CLLocation *))onComplete {
    [locationManager startUpdatingLocation];
    self.onFoundLocation = onComplete;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    onFoundLocation(newLocation);
    self.onFoundLocation = nil;
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    onFoundLocation(nil);
    self.onFoundLocation = nil;
}

- (void) decodeLocation:(CLLocation *)location complete:(DecodedLocationBlock)onComplete {
    [coder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && !error) {
            onComplete(placemarks);
        } else {
            onComplete(nil);
        }
    }];
}

#pragma mark - Random location

static float randomFraction() {
    signed int r = rand() % 100;
    int neg = rand() % 2;
    
    float frac = ((float) r)/100;
    if (neg) frac *= -1;
    
    return frac;
}

- (CLLocation *) randomLocationNear:(CLLocationCoordinate2D)center latitudeRange:(CLLocationDegrees)latRange longitudeRange:(CLLocationDegrees)longRange {    
    
    float latDiff =  randomFraction() * (latRange);
    float longDiff = randomFraction() * (longRange);
    
    CLLocation * new = [[CLLocation alloc] initWithLatitude:center.latitude+latDiff longitude:center.longitude+longDiff];
    return [new autorelease];
}

- (void) validateLocation:(CLLocation *)location complete:(ValidatedLocationBlock)onComplete {  
    
    [self decodeLocation:location complete:^(NSArray *placemarks) {
        
        if (!placemarks || [placemarks count] == 0) {
            onComplete(NO, nil);
            return;
        }
        
        BOOL inTheGoddamnOcean = NO;
        for (CLPlacemark * p in placemarks) {
            if (p.inlandWater || p.ocean) {
                inTheGoddamnOcean = YES;
                break;
            }
        }
        
        CLPlacemark * p = [[[placemarks objectAtIndex:0] copy] autorelease];
        
        onComplete(inTheGoddamnOcean == NO, p);
    }];
}



@end
