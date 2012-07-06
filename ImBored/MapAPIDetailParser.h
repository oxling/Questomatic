//
//  MapAPIDetailParser.h
//  ImBored
//
//  Created by Amy Dyer on 4/8/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Quest;
@interface MapAPIDetailParser : NSObject

- (void) parseDetailResults:(NSData *) data intoQuest:(Quest *)quest;

@end
