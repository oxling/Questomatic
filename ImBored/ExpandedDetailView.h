//
//  ExpandedDetailView.h
//  ImBored
//
//  Created by Amy Dyer on 2/5/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import <UIKit/UIKit.h>

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> expandedview
=======
>>>>>>> expandedview
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
}

@property (nonatomic, retain) IBOutlet UITextView * addressTextView;
@property (nonatomic, retain) IBOutlet UIImageView * imageView;

@property (nonatomic, assign) id <ExpandedDetailViewDelegate> delegate;

- (IBAction)didTapComplete:(id)sender;
- (IBAction)didTapCancel:(id)sender;
- (IBAction)didTapViewMap:(id)sender;
<<<<<<< HEAD
<<<<<<< HEAD
=======
@interface ExpandedDetailView : UIView
>>>>>>> 6ba3996... Ignoring more files...
=======
>>>>>>> expandedview
=======
>>>>>>> expandedview

@end