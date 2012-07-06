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

@interface MapAPIResultParser : NSObject {    

}


- (NSArray *) parseLocationResults:(NSData *) data;

@end
