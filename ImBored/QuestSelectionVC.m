//
//  QuestSelectionVC.m
//  ImBored
//
//  Created by Amy Dyer on 1/22/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "QuestSelectionVC.h"

@implementation QuestSelectionVC
@synthesize table;

- (id) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) dealloc {
    [table release];
    [questTypes release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
