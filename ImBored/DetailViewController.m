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
#import "MapAPIController.h"

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
    UITapGestureRecognizer * tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBack:)];
    [questView addGestureRecognizer:tapper];
    [tapper release];
    
    addressTextView.text = quest.address;
    [questView setShowsLeftTriangle:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:quest.iconURL]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView setImage:img];
        });
    });
    
    if (quest.websiteURL == nil) {
    
        MapAPIController * ctr = [[MapAPIController alloc] init];
        [ctr detailsOfQuest:quest onComplete:^(Quest *location) {
            DebugLog(@"Loaded URL for quest: %@", quest.websiteURL);
            [ctr release];
        }];

    }
    
}

- (void) viewDidUnload {
    [super viewDidUnload];
    
    self.questView = nil;
    self.addressTextView = nil;
    self.imageView = nil;
}

- (void) didTapBack:(UITapGestureRecognizer *)tapper {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) didTapCancel:(id)sender {
    //TODO
}

- (void) didTapComplete:(id)sender {
    //TODO
}

- (void) didTapViewMap:(id)sender {
    [[UIApplication sharedApplication] openURL:[quest getLink]];
}



@end
