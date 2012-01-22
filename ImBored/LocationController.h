//
//  LocationController.h
//  ImBored
//
//  Created by Amy Dyer on 1/22/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^FoundLocationBlock)(CLLocation *newLocation);
typedef void (^DecodedLocationBlock)(NSArray *placemarks);
typedef void (^ValidatedLocationBlock)(BOOL valid, CLPlacemark * placemark);

@interface LocationController : NSObject <CLLocationManagerDelegate> {
    CLLocationCoordinate2D userCoordinates;
    CLLocationManager * locationManager;
    CLGeocoder * coder;
    
    FoundLocationBlock onFoundLocation;
}

@property (nonatomic, copy) FoundLocationBlock onFoundLocation;

- (void) startUpdatingUserLocation:(FoundLocationBlock)onComplete;
- (void) stopUpdatingUserLocation;
- (CLLocation *) randomLocationNear:(CLLocationCoordinate2D)center latitudeRange:(CLLocationDegrees)latDiff longitudeRange:(CLLocationDegrees)longDiff;

- (void) decodeLocation:(CLLocation *)location complete:(DecodedLocationBlock)onComplete;
- (void) validateLocation:(CLLocation *)location complete:(ValidatedLocationBlock)onComplete;

@end
