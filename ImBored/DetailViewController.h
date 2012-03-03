//
//  ExpandedDetailView.h
//  ImBored
//
//  Created by Amy Dyer on 2/5/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuestDetailView, Quest;
@interface DetailViewController : UIViewController {
    UITextView * addressTextView;
    UIImageView * imageView;
    QuestDetailView * questView;
    
    Quest * quest;
}

@property (nonatomic, retain) IBOutlet UITextView * addressTextView;
@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) IBOutlet QuestDetailView * questView;
@property (nonatomic, retain) Quest * quest;

- (IBAction)didTapComplete:(id)sender;
- (IBAction)didTapCancel:(id)sender;
- (IBAction)didTapViewMap:(id)sender;

@end
