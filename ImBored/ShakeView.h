//
//  ShakeView.h
//  ImBored
//
//  Created by Amy Dyer on 1/22/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ShakeView : UIView {
    CALayer * shadowLayer;
    CALayer * backgroundLayer;
    
    UILabel * label;
}

- (void) animateAddToSuperView:(UIView *)view;
- (void) animateRemoveFromSuperView;

@end
