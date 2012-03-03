//
//  ExpandedDetailView.m
//  ImBored
//
//  Created by Amy Dyer on 2/5/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import "DetailViewController.h"
#import "QuestDetailView.h"
#import "Quest.h"

@implementation DetailViewController
@synthesize addressTextView, imageView, quest, questView;

- (void) dealloc {
    [addressTextView release];
    [imageView release];
    [quest release];
    [questView release];
    
    [super dealloc];
}

- (void) viewDidLoad {
    [questView setQuest:[NSString stringWithFormat:@"Your quest is to %@", [quest getVerb]] withTitle:quest.title];
    [questView setNeedsDisplay];
    
    addressTextView.text = quest.address;
}

- (void) didTapCancel:(id)sender {
    
}

- (void) didTapComplete:(id)sender {
    
}

- (void) didTapViewMap:(id)sender {
    [[UIApplication sharedApplication] openURL:[quest getLink]];
}



@end
