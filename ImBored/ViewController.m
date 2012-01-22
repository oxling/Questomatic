//
//  ViewController.m
//  ImBored
//
//  Created by Amy Dyer on 1/21/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AddressBook/ABPerson.h>

#import "MapAPIController.h"
#import "LocationController.h"

@implementation ViewController
@synthesize map, button, currentPoint, userLocation;

- (void) initVariables { 
    locationController = [[LocationController alloc] init];
    
    srand(time(NULL));
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initVariables];
    }
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initVariables];
    }
    return self;
}

- (void) dealloc{
    [button release];
    [map release];
    [currentPoint release];
    [locationController release];
    [userLocation release];
    
    [super dealloc];
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) {
        [self didTapRandom:nil];
    }
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (annotation == self.currentPoint || annotation == userLocation) {
        static NSString * const identifer = @"mapview_id";
        MKPinAnnotationView * pin = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifer];
        if (!pin) {
            pin = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifer] autorelease];
        }
        
        pin.annotation = annotation;
        
        if (annotation == userLocation) {
            pin.canShowCallout = YES;
            pin.pinColor = MKPinAnnotationColorGreen;
        } else {
            pin.canShowCallout = YES;
            pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pin.pinColor = MKPinAnnotationColorRed;
        }
        
        return pin;
    } else return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Maps", nil];
    [sheet showInView:self.view];
    [sheet release];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    } else {
        CLLocationCoordinate2D newCoord = [self.currentPoint coordinate];
        CLLocationCoordinate2D oldCoord = [map.userLocation coordinate];
        NSString * urlStr = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%f,%f&daddr=%f,%f", 
                             oldCoord.latitude, oldCoord.longitude,
                             newCoord.latitude, newCoord.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
}


- (void) generateRandomLocation {
    
    [locationController randomLocationNear:map.region.center
                             latitudeRange:map.region.span.latitudeDelta/2
                            longitudeRange:map.region.span.longitudeDelta/2
                                  complete:^(Location *location) {
                                      if (self.currentPoint)
                                          [map removeAnnotation:self.currentPoint];
                                      
                                      if (location) {                    
                                          [map addAnnotation:location];
                                          self.currentPoint = location;
                                      }
                                      
                                      [map setCenterCoordinate:[self.currentPoint coordinate] animated:YES];
                                      [map setSelectedAnnotations:[NSArray arrayWithObject:self.currentPoint]];
                                      
                                      button.enabled = YES;
                                      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

                                  }];        
}

- (void) didTapRandom:(id)sender {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    button.enabled = NO;
    [self generateRandomLocation];
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [locationController startUpdatingUserLocation:^(CLLocation *newLocation) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [locationController stopUpdatingUserLocation];

        if (newLocation) {
            map.centerCoordinate = newLocation.coordinate;
            MKCoordinateSpan span = MKCoordinateSpanMake(0.03, 0.03);
            map.region = MKCoordinateRegionMake(newLocation.coordinate, span);
            
            Location * loc = [[Location alloc] init];
            loc.title = @"Me";
            loc.coordinate = newLocation.coordinate;
            self.userLocation = loc;
            
            [map addAnnotation:userLocation];
            
            [loc release];
        } else {
            //TODO: warning
        }
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [self resignFirstResponder];
    [locationController stopUpdatingUserLocation];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
