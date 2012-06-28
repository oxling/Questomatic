//
//  QuestDetailView.h
//  ImBored
//
//  Created by Amy Dyer on 1/28/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailLayerDelegate, TriangleView;
@interface QuestDetailView : UIView {
    CALayer * backgroundLayer;
    UILabel * questLabel;
    UILabel * titleLabel;
    
    DetailLayerDelegate * del;
    TriangleView * triangle;
}

- (void) setQuest:(NSString *)questString withTitle:(NSString *)titleString;
- (void) setShowsRightTriangle:(BOOL)showTriangle;
- (void) setShowsLeftTriangle:(BOOL)showTriangle;


@end
