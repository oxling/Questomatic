//
//  ViewController.h
//  ImBored
//
//  Created by Amy Dyer on 1/21/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKMapView.h>
#import <MapKit/MKPlaceMark.h>

#import "MapAPIController.h"
#import "LocationController.h"

#import "Quest.h"

#import "ShakeView.h"

@interface ViewController : UIViewController <MKMapViewDelegate, UIActionSheetDelegate> {
    MKMapView * map;
    UIButton * button;
    
    Quest * currentPoint;
    Quest * userLocation;
    
    LocationController * locationController;
    ShakeView * shakeView;
    
    NSTimer * actionTimer;
}
@property (nonatomic, retain) IBOutlet MKMapView * map;
@property (nonatomic, retain) Quest * currentPoint;
@property (nonatomic, retain) Quest * userLocation;

- (id) randomItem:(id)item, ... NS_REQUIRES_NIL_TERMINATION;

@end
