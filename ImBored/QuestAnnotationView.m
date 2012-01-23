//
//  QuestAnnotationView.m
//  ImBored
//
//  Created by Amy Dyer on 1/22/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "QuestAnnotationView.h"
#import "LocationCalloutView.h"

@implementation QuestAnnotationView

- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]; 
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.frame = CGRectMake(0, 0, 25, 25);
        self.image = nil;
        
    }
    return self;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected) {
        self.backgroundColor = [UIColor whiteColor];
        if (!callout) {
            callout = [[LocationCalloutView alloc] init];
            callout.frame = CGRectMake(0, 0, 200, 220);
        }
        [self addSubview:callout];
    } else {
        [callout removeFromSuperview];
        [callout release];
        callout = nil;
        
        self.backgroundColor = [UIColor redColor];
    }
}

- (void) dealloc {
    [callout release];
    [super dealloc];
}

@end
