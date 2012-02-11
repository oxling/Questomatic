//
//  ExpandedDetailView.m
//  ImBored
//
//  Created by Amy Dyer on 2/5/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "ExpandedDetailView.h"

@implementation ExpandedDetailView
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> expandedview
=======
>>>>>>> expandedview
@synthesize addressTextView, imageView, delegate;

- (void) dealloc {
    [addressTextView release];
    [imageView release];
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

<<<<<<< HEAD
<<<<<<< HEAD
=======

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
>>>>>>> 6ba3996... Ignoring more files...
=======
>>>>>>> expandedview
=======
>>>>>>> expandedview

@end
