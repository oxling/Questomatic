//
//  ExpandedDetailView.h
//  ImBored
//
//  Created by Amy Dyer on 2/5/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExpandedDetailViewDelegate <NSObject>

@optional
- (void) didCompleteQuest;
- (void) didCancelQuest;
- (void) didViewQuest;

@end

@interface ExpandedDetailView : UIView {
    UITextView * addressTextView;
    UIImageView * imageView;
    
    id <ExpandedDetailViewDelegate> delegate;
    id quest;
}

@property (nonatomic, retain) IBOutlet UITextView * addressTextView;
@property (nonatomic, retain) IBOutlet UIImageView * imageView;

@property (nonatomic, assign) id <ExpandedDetailViewDelegate> delegate;
@property (nonatomic, retain) id quest;

- (IBAction)didTapComplete:(id)sender;
- (IBAction)didTapCancel:(id)sender;
- (IBAction)didTapViewMap:(id)sender;

@end
