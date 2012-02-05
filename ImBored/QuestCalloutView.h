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
@class QuestCalloutView;
@protocol QuestCalloutDelegate <NSObject>

@optional
- (void) didAcceptQuest:(id)quest inView:(QuestCalloutView *)view;
- (void) didTapCalloutView:(QuestCalloutView *)view;

@end

@interface QuestCalloutView : MKAnnotationView <UIWebViewDelegate> {
    CALayer * backgroundLayer;
    CALayer * smallLayer;
    
    UILabel * titleLabel;
    UILabel * subtitleLabel;
    UILabel * questLabel;
    
    UIButton * acceptButton;
    
    UIView * labelContainer;
    
    NSString * htmlString;
    UIWebView * htmlView;
    
    UITapGestureRecognizer * tapper;
    
    id <QuestCalloutDelegate> delegate;
}

@property (nonatomic, readonly) UIButton * acceptButton;

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * questString;
@property (nonatomic, retain) NSString * htmlString;
@property (nonatomic, assign) id <QuestCalloutDelegate> delegate;

- (void) updateFrameAndLabels;
- (CGFloat) contentHeight;
- (void) didTapAccept;
- (void) updateButtonStyle:(BOOL)enabled;

@end