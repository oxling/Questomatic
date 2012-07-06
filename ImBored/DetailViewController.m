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
@synthesize viewWebsiteButton;
@synthesize addressTextView, imageView, quest, questView;

- (void) dealloc {
    [addressTextView release];
    [imageView release];
    [quest release];
    [questView release];
    
    [viewWebsiteButton release];
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
        viewWebsiteButton.enabled = NO;
        
        MapAPIController * ctr = [[MapAPIController alloc] init];
        [ctr detailsOfQuest:quest onComplete:^(Quest *location) {
            [ctr release];
            if (quest.websiteURL) {
                viewWebsiteButton.enabled = YES;
            }
        }];

    }
    
}

- (void) viewDidUnload {
    [self setViewWebsiteButton:nil];
    [super viewDidUnload];
    
    self.questView = nil;
    self.addressTextView = nil;
    self.imageView = nil;
}

- (void) didTapBack:(UITapGestureRecognizer *)tapper {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) didTapComplete:(id)sender {
    //TODO
}

- (void) didTapViewMap:(id)sender {
    [[UIApplication sharedApplication] openURL:[quest getLink]];
}

- (IBAction)didTapViewWebsite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:quest.websiteURL]];
}

@end
