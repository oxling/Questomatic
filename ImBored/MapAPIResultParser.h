//
//  MapAPIResultParser.h
//  ImBored
//
//  Created by Amy Dyer on 1/21/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
#import <CoreLocation/CoreLocation.h>

@interface Result : NSObject <MKAnnotation> {
@private
    NSMutableString * latitude;
    NSMutableString * longitude;
    NSMutableString * name;
    NSMutableString * address;
    
    NSMutableString * type;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;

@property (nonatomic, readonly) NSMutableString * latitude;
@property (nonatomic, readonly) NSMutableString * longitude;
@property (nonatomic, readonly) NSMutableString * name;
@property (nonatomic, readonly) NSMutableString * address;
@property (nonatomic, readonly) NSMutableString * type;

@end


typedef void (^ParseCompleteBlock)(NSArray * places);
typedef void (^FailBlock)();

@interface MapAPIResultParser : NSObject <NSXMLParserDelegate> {    
    Result * result;
    NSString * element;
    NSMutableArray * resultArray;
}

@property (nonatomic, retain) Result * result;
@property (nonatomic, retain) NSString * element;

- (NSArray *) parseResults:(NSData *)data;

@end
