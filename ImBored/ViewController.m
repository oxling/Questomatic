

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
#import "QuestCalloutView.h"
#import "QuestDetailView.h"

@implementation ViewController
@synthesize map, currentPoint, userLocation, acceptedQuest;

BOOL fireActivityTimer;

- (void) initVariables { 
    locationController = [[LocationController alloc] init];
    shakeView = [[ShakeView alloc] initWithFrame:CGRectMake(0, 0, 176, 126)];
    shakeView.center = self.view.center;
    shakeView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    detailView = [[QuestDetailView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    detailView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
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
    [map release];
    [currentPoint release];
    [locationController release];
    [userLocation release];
    [shakeView release];
    [detailView release];
    [acceptedQuest release];
    
    [super dealloc];
}

#pragma mark - Actions

- (void) activityOccured {
    if (fireActivityTimer) {
        [actionTimer invalidate];
        actionTimer = nil;
    
        [shakeView animateRemoveFromSuperView];
        actionTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(noActivity) userInfo:nil repeats:NO];
    }
}

- (void) noActivity {
    [actionTimer invalidate];
    actionTimer = nil;
    
    [shakeView animateAddToSuperView:self.view];
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) {
        [self didTapRandom];
        [self activityOccured];
    }
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

#pragma mark - Accept quest
- (void) setAcceptedQuest:(Quest *)newAcceptedQuest {
    if (newAcceptedQuest == acceptedQuest)
        return;
    
    [acceptedQuest release];
    acceptedQuest = [newAcceptedQuest retain];
    
    if (acceptedQuest) {
        [self.view addSubview:detailView];
        detailView.titleString = acceptedQuest.title;
        detailView.questString = [NSString stringWithFormat:@"Your quest is to %@", [acceptedQuest getVerb]];
    } else {
        [detailView removeFromSuperview];
    }
}

#pragma mark - Map

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    [self activityOccured];
}

- (void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    [self activityOccured];
    if ([view.annotation isKindOfClass:[Quest class]]) {
        self.acceptedQuest = (Quest *)view.annotation;
    }
}

- (void) mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [self activityOccured];
}

- (void) mapViewWillStartLoadingMap:(MKMapView *)mapView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void) mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void) mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (annotation == self.currentPoint) {
        static NSString * const identifer = @"mapview_id_quest";
        QuestCalloutView * pin = (QuestCalloutView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifer];
        if (!pin) {
            pin = [[[QuestCalloutView alloc] initWithAnnotation:annotation reuseIdentifier:identifer] autorelease];
        }
        
        Quest * q = (Quest *)annotation;
        
        pin.annotation = annotation;
        pin.title = q.title;
        pin.subtitle = q.subtitle;
        pin.questString = [UtilityKit capitalizeString:[q getVerb]];
        pin.htmlString = [q listings];
        
        [pin updateFrameAndLabels];
        
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
                                  complete:^(Quest *location) {
                                      if (self.currentPoint)
                                          [map removeAnnotation:self.currentPoint];
                                      
                                      if (location) {                    
                                          [map addAnnotation:location];
                                          self.currentPoint = location;
                                      }
                                      
                                      [map setCenterCoordinate:[self.currentPoint coordinate] animated:YES];
                                      
                                      button.enabled = YES;
                                      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

                                  }];        
}

- (void) didTapRandom {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    button.enabled = NO;
    [self generateRandomLocation];
}

#pragma mark - View management

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
            
            [map setRegion:MKCoordinateRegionMake(newLocation.coordinate, span) animated:YES];

            Quest * loc = [[Quest alloc] init];
            loc.title = @"Me";
            loc.coordinate = newLocation.coordinate;
            
            
            if (self.userLocation) 
                [map removeAnnotation:userLocation];
            
            self.userLocation = loc;
            [map addAnnotation:userLocation];
            [loc release];
            
            fireActivityTimer = YES;
            [self noActivity];
            
        } else {
            CLLocationCoordinate2D coord =  CLLocationCoordinate2DMake(42.378075, -71.044464);
            MKCoordinateSpan span = MKCoordinateSpanMake(0.20, 0.20);
            [map setRegion:MKCoordinateRegionMake(coord, span) animated:YES];
            
            [[[[UIAlertView alloc] initWithTitle:@"GPS Problem" message:@"Unable to find your coordinates. Zoom in where you would like to search for a quest." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
            
            fireActivityTimer = YES;
        }
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [self resignFirstResponder];
    
    [locationController stopUpdatingUserLocation];
    
    fireActivityTimer = NO;
    [actionTimer invalidate];
    actionTimer = nil;
    
    [shakeView removeFromSuperview];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    fireActivityTimer = NO;
    return YES;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    fireActivityTimer = YES;
}

@end
