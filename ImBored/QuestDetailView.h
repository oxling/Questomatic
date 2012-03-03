//
//  QuestDetailView.h
//  ImBored
//
//  Created by Amy Dyer on 1/28/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailLayerDelegate;
@interface QuestDetailView : UIView {
    CALayer * backgroundLayer;
    UILabel * questLabel;
    UILabel * titleLabel;
    
    DetailLayerDelegate * del;
}

- (void) setQuest:(NSString *)questString withTitle:(NSString *)titleString;


@end
