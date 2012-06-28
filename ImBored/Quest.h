//
//  Location.h
//  ImBored
//
//  Created by Amy Dyer on 1/22/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <MapKit/MKAnnotation.h>

@interface Quest : NSObject <MKAnnotation> {
    
@private
    NSString * _name;
    NSString * _address;
    NSMutableArray * _types;
    NSString * _listings;
    NSString * _iconURL;
    NSString * _websiteURL;
    NSString * _reference;
    
    NSString * _title;
    NSString * _subtitle;
    
    NSString * _verb;
    
    CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, readonly) NSMutableArray * types;
@property (nonatomic, copy) NSString * listings;
@property (nonatomic, copy) NSString * iconURL;
@property (nonatomic, copy) NSString * reference;
@property (nonatomic, copy) NSString * websiteURL;

- (NSString *) getVerb;
- (NSURL *) getLink;

@end

