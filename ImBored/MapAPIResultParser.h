//
//  MapAPIResultParser.h
//  ImBored
//
//  Created by Amy Dyer on 1/21/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "Quest.h"

typedef void (^ParseCompleteBlock)(NSArray * places);
typedef void (^FailBlock)();

@interface MapAPIResultParser : NSObject <NSXMLParserDelegate> {    
    Quest * result;
    NSString * element;
    NSMutableArray * resultArray;
}

@property (nonatomic, retain) Quest * result;
@property (nonatomic, retain) NSString * element;

- (NSArray *) parseResults:(NSData *)data;

@end
