//
//  LocationController.m
//  ImBored
//
//  Created by Amy Dyer on 1/22/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "LocationController.h"
#import <AddressBook/ABPerson.h>

@implementation LocationController
@synthesize onFoundLocation;

#pragma mark - Memory

- (id) init {
    self = [super init];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        coder = [[CLGeocoder alloc] init];
        mapController = [[MapAPIController alloc] init];
    }
    
    return self;
}

- (void) dealloc {
    [locationManager release];
    [coder release];
    [onFoundLocation release];
    [mapController release];
    
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
    [manager stopUpdatingLocation];
    
    if (onFoundLocation) {
        onFoundLocation(newLocation);
        self.onFoundLocation = nil;
    }
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (onFoundLocation) {
        onFoundLocation(nil);
        self.onFoundLocation = nil;
    }
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

- (CLLocation *) clLocation:(CLLocationCoordinate2D)center latitudeRange:(CLLocationDegrees)latRange longitudeRange:(CLLocationDegrees)longRange {    
    
    float latDiff =  randomFraction() * (latRange);
    float longDiff = randomFraction() * (longRange);
    
    CLLocation * new = [[CLLocation alloc] initWithLatitude:center.latitude+latDiff longitude:center.longitude+longDiff];
    return [new autorelease];
}

UInt8 tryCount = 0;
- (void) randomLocationNear:(CLLocationCoordinate2D)center 
                    latitudeRange:(CLLocationDegrees)latDiff longitudeRange:(CLLocationDegrees)longDiff 
                         complete:(QuestLocationBlock)onComplete

{
    CLLocation * newLoc = [self clLocation:center latitudeRange:latDiff longitudeRange:longDiff];
    [self validateLocation:newLoc complete:^(BOOL valid, CLPlacemark *placemark) {
        
        //If it's not valid, try again.
        if (!valid) {
            if (tryCount < 10) {
                tryCount++;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self randomLocationNear:center latitudeRange:latDiff longitudeRange:longDiff complete:[[onComplete copy] autorelease]];
                });
                
            //Couldn't reverse geocode it, or maybe the user is looking at the ocean
            } else {
                tryCount = 0;
                
                Location * loc = [[Location alloc] init];
                loc.coordinate = newLoc.coordinate;
                loc.title = @"Unknown Location";
                loc.subtitle = [NSString stringWithFormat:@"%0.6f, %0.6f", loc.coordinate.latitude, loc.coordinate.longitude];
                
                onComplete(loc);
                
                [loc release];
            }
        }
        
        else {
            [mapController requestNearLocation:newLoc onComplete:^(Location *location) {
                
                //If the map controller gave us a location, great!
                if (location) {
                    onComplete(location);
                }
                
                //Otherwise, we need to generate a new one based on geocoded data
                else {
                    Location * loc = [[Location alloc] init];
                    loc.coordinate = placemark.location.coordinate;
                    
                    
                    if ([placemark.areasOfInterest count] > 0) {
                        loc.title = [placemark.areasOfInterest objectAtIndex:0];
                    } else {
                        loc.title = placemark.name;
                    }
                    
                    loc.subtitle = [self addressStringFromDictionary:placemark.addressDictionary withName:placemark.name];
                    
                    onComplete(loc);
                    
                    [loc release];
                }
            }];
        }
        
    }];
    
}

- (NSString *) addressStringFromDictionary:(NSDictionary *)dict withName:(NSString *)name{
    NSMutableString * str = [NSMutableString string];
    
    NSString * street = [dict objectForKey:(NSString *)kABPersonAddressStreetKey];
    NSString * city = [dict objectForKey:(NSString *)kABPersonAddressCityKey];
    NSString * state = [dict objectForKey:(NSString *)kABPersonAddressStateKey];
    NSString * country = [dict objectForKey:(NSString *)kABPersonAddressCountryKey];
    
    if (street) [str appendFormat:@"%@, ", street];
    if (city && [name isEqualToString:city] == NO) [str appendFormat:@"%@, ", city];
    if (state && [name isEqualToString:state] == NO) [str appendFormat:@"%@, ", state];
    
    [str appendFormat:@"%@", country];
    return [NSString stringWithString:str];
    
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
