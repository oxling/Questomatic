//
//  LocationCalloutView.h
//  ImBored
//
//  Created by Amy Dyer on 1/22/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>

@interface QuestCalloutView : MKAnnotationView {
    CALayer * backgroundLayer;
    UILabel * titleLabel;
    UILabel * subtitleLabel;
    UILabel * questLabel;
}

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * questString;

@end