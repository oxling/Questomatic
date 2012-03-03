//
//  ExpandedDetailView.m
//  ImBored
//
//  Created by Amy Dyer on 2/5/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "ExpandedDetailView.h"

@implementation ExpandedDetailView
@synthesize addressTextView, imageView, delegate, quest;;

- (void) dealloc {
    [addressTextView release];
    [imageView release];
    [quest release];
    
    [super dealloc];
}

- (void) didTapCancel:(id)sender {
    
    if ([delegate respondsToSelector:@selector(didCancelQuest)]) {
        [delegate didCancelQuest];
    }
}

- (void) didTapComplete:(id)sender {
    
    if ([delegate respondsToSelector:@selector(didCompleteQuest)]) {
        [delegate didCompleteQuest];
    }
}

- (void) didTapViewMap:(id)sender {
    if ([delegate respondsToSelector:@selector(didViewQuest)]) {
        [delegate didViewQuest];
    }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
