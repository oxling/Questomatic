//
//  MapAPIController.h
//  ImBored
//
//  Created by Amy Dyer on 1/21/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
#import "Quest.h"

typedef void (^CompleteBlock)(Quest * location);

@interface MapAPIController : NSObject <NSURLConnectionDelegate> {
    NSURLConnection * connection;
    CompleteBlock block;
    NSMutableData * data;
}
@property (nonatomic, retain) NSURLConnection * connection;
@property (nonatomic, retain) NSMutableData * data;
@property (nonatomic, copy) CompleteBlock block;

- (void) requestNearLocation:(CLLocation *)location onComplete:(CompleteBlock)complete;

@end
