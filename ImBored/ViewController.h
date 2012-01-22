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

#import "Location.h"

#import "ShakeView.h"

@interface ViewController : UIViewController <MKMapViewDelegate, UIActionSheetDelegate> {
    MKMapView * map;
    UIButton * button;
    
    Location * currentPoint;
    Location * userLocation;
    
    LocationController * locationController;
    ShakeView * shakeView;
    
    NSTimer * actionTimer;
}
@property (nonatomic, retain) IBOutlet MKMapView * map;
@property (nonatomic, retain) IBOutlet UIButton * button;
@property (nonatomic, retain) Location * currentPoint;
@property (nonatomic, retain) Location * userLocation;

- (IBAction)didTapRandom:(id)sender;

@end
