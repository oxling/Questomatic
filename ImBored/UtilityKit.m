//
//  UtilityKit.m
//  ImBored
//
//  Created by Amy Dyer on 2/4/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "UtilityKit.h"

@implementation UtilityKit

+ (id) randomItem:(id) item, ... {
    NSMutableArray * array = [NSMutableArray array];
    
    va_list args;
    va_start(args, item);
    for (id arg = item; arg != nil; arg = va_arg(args, id)) {
        [array addObject:arg];
    }
    va_end(args);
    
    int indx = rand() % [array count];
    
    NSAssert(indx < [array count], @"Random index %i out of bounds for array %@", indx, array);
    
    return [array objectAtIndex:indx];
}

+ (NSString *) capitalizeString:(NSString *)str {
    if (str && [str length] > 0) {
        char c = [str characterAtIndex:0];
        if (c >= 'a' && c <= 'z') {
            c-= ('a' - 'A');
        }
        return [NSString stringWithFormat:@"%c%@", c, [str substringFromIndex:1]];
    } else 
        return nil;
}



@end
