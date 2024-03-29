//
//  UtilityKit.h
//  ImBored
//
//  Created by Amy Dyer on 2/4/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilityKit : NSObject

+ (id) randomItem:(id) item, ... NS_REQUIRES_NIL_TERMINATION;
+ (NSString *) capitalizeString:(NSString *)str;
+ (CGRect) roundFrame:(CGRect)rect;

@end
