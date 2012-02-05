//
//  QuestDetailView.h
//  ImBored
//
//  Created by Amy Dyer on 1/28/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestDetailView : UIView {
    CALayer * backgroundLayer;
    UILabel * questLabel;
    UILabel * titleLabel;
}
@property (nonatomic, retain) NSString * titleString;
@property (nonatomic, retain) NSString * questString;


@end