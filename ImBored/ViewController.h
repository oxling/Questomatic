//
//  ViewController.h
//  ImBored
//
//  Created by Amy Dyer on 1/21/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <MapKit/MKMapView.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate> {
    MKMapView * map;
    UIButton * button;
    
    id lastPoint;
}
@property (nonatomic, retain) IBOutlet MKMapView * map;
@property (nonatomic, retain) IBOutlet UIButton * button;
@property (nonatomic, retain) id lastPoint;

- (IBAction)didTapRandom:(id)sender;

@end
