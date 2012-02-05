//
//  Location.h
//  ImBored
//
//  Created by Amy Dyer on 1/22/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <MapKit/MKAnnotation.h>

@interface Quest : NSObject <MKAnnotation> {
    
@private
    NSMutableString * latitude;
    NSMutableString * longitude;
    NSMutableString * name;
    NSMutableString * address;
    NSMutableArray * types;
    NSMutableString * listings;
    
    NSString * title;
    NSString * subtitle;
    NSString * verb;
    
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;

@property (nonatomic, readonly) NSMutableString * latitude;
@property (nonatomic, readonly) NSMutableString * longitude;
@property (nonatomic, readonly) NSMutableString * name;
@property (nonatomic, readonly) NSMutableString * address;
@property (nonatomic, readonly) NSMutableArray * types;
@property (nonatomic, readonly) NSMutableString * listings;

- (NSString *) getVerb;

@end

