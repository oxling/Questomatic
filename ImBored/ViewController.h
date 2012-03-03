//
//  ViewController.h
//  ImBored
//
//  Created by Amy Dyer on 1/21/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKMapView.h>
#import <MapKit/MKPlaceMark.h>

#import "MapAPIController.h"
#import "LocationController.h"

#import "Quest.h"

#import "InfoView.h"
#import "QuestDetailView.h"
#import "QuestCalloutView.h"
#import "DetailViewController.h"

@interface ViewController : UIViewController <MKMapViewDelegate, UIActionSheetDelegate, QuestCalloutDelegate> {
    MKMapView * map;
    UIButton * button;
    
    Quest * visibleQuest;
    Quest * userLocation;
    Quest * acceptedQuest;
    
    LocationController * locationController;
    InfoView * infoView;
    QuestDetailView * detailView;
    
    UIView * overlayView;
    UIActivityIndicatorView * activityView;
    
    NSTimer * actionTimer;
}
@property (nonatomic, retain) IBOutlet MKMapView * map;
@property (nonatomic, retain) Quest * visibleQuest;
@property (nonatomic, retain) Quest * userLocation;
@property (nonatomic, retain) Quest * acceptedQuest;

- (void) didTapRandom;

@end
