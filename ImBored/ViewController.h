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

@interface ViewController : UIViewController <MKMapViewDelegate, UIActionSheetDelegate> {
    MKMapView * map;
    UIButton * button;
    
    id lastPoint;
    MKPlacemark * home;
    
    CLLocation * userLocation;
    
    MapAPIController * mapController;
    LocationController * locationController;
}
@property (nonatomic, retain) IBOutlet MKMapView * map;
@property (nonatomic, retain) IBOutlet UIButton * button;
@property (nonatomic, retain) id <MKAnnotation> lastPoint;
@property (nonatomic, retain) CLLocation * userLocation;

- (IBAction)didTapRandom:(id)sender;

@end
