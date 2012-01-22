//
//  LocationController.h
//  ImBored
//
//  Created by Amy Dyer on 1/22/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MapAPIController.h"

typedef void (^FoundLocationBlock)(CLLocation *newLocation);
typedef void (^DecodedLocationBlock)(NSArray *placemarks);
typedef void (^ValidatedLocationBlock)(BOOL valid, CLPlacemark * placemark);
typedef void (^QuestLocationBlock)(Location * location);

@interface LocationController : NSObject <CLLocationManagerDelegate> {
    CLLocationCoordinate2D userCoordinates;
    CLLocationManager * locationManager;
    CLGeocoder * coder;
    
    FoundLocationBlock onFoundLocation;
    MapAPIController * mapController;
}

@property (nonatomic, copy) FoundLocationBlock onFoundLocation;

- (void) startUpdatingUserLocation:(FoundLocationBlock)onComplete;
- (void) stopUpdatingUserLocation;
- (void) randomLocationNear:(CLLocationCoordinate2D)center latitudeRange:(CLLocationDegrees)latDiff longitudeRange:(CLLocationDegrees)longDiff complete:(QuestLocationBlock)onComplete;

- (void) decodeLocation:(CLLocation *)location complete:(DecodedLocationBlock)onComplete;
- (void) validateLocation:(CLLocation *)location complete:(ValidatedLocationBlock)onComplete;

- (NSString *) addressStringFromDictionary:(NSDictionary *)dict withName:(NSString *)name;

@end
