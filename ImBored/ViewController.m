

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
@synthesize map, visibleQuest, userLocation, acceptedQuest;

BOOL fireActivityTimer = NO;

- (void) initVariables { 
    locationController = [[LocationController alloc] init];
    
    infoView = [[InfoView alloc] initWithFrame:CGRectMake(0, 0, 176, 126)];
    infoView.center = self.view.center;
    infoView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    detailView = [[QuestDetailView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    detailView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    overlayView = [[UIView alloc] initWithFrame:self.view.frame];
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    overlayView.backgroundColor = [UIColor blackColor];
    overlayView.alpha = 0.45;
        
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = overlayView.center;
    activityView.frame = [UtilityKit roundFrame:activityView.frame];
    activityView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
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
    [visibleQuest release];
    [locationController release];
    [userLocation release];
    [infoView release];
    [detailView release];
    [acceptedQuest release];
    [overlayView release];
    [activityView release];
    
    [super dealloc];
}

#pragma mark - Actions

- (NSString *) labelString {
    NSString * device = [[UIDevice currentDevice] model];
    return [NSString stringWithFormat:@"Shake your %@ to find a new quest on the map", device];
}

- (void) activityOccured {
    if (fireActivityTimer) {
        [actionTimer invalidate];
        actionTimer = nil;
    
        [infoView animateRemoveFromSuperView];
        actionTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(noActivity) userInfo:nil repeats:NO];
    }
}

- (void) noActivity {
    [actionTimer invalidate];
    actionTimer = nil;
    
    [infoView animateAddToSuperView:self.view];
    infoView.label.text = [self labelString];
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
        [detailView setQuest:[NSString stringWithFormat:@"Your quest is to %@", [acceptedQuest getVerb]] withTitle:acceptedQuest.title];
    } else {
        [detailView removeFromSuperview];
    }
}

- (void) didAcceptQuest:(id)quest inView:(QuestCalloutView *)view {
    NSAssert([quest isKindOfClass:[Quest class]], @"Annotation %@ must be of class Quest", quest);
    
    self.acceptedQuest = quest;
    view.acceptButton.enabled = NO;
    [view updateButtonStyle:NO];
}

- (void) didTapCalloutView:(QuestCalloutView *)view {
    [map deselectAnnotation:view.annotation animated:YES];
}

#pragma mark - Map

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    [self activityOccured];
}

- (void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    [self activityOccured];
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
    if (annotation == self.visibleQuest) {
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
        pin.delegate = self;
        pin.acceptButton.enabled = YES;
        [pin updateButtonStyle:YES];
        
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
        CLLocationCoordinate2D newCoord = [self.visibleQuest coordinate];
        CLLocationCoordinate2D oldCoord = [map.userLocation coordinate];
        NSString * urlStr = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%f,%f&daddr=%f,%f", 
                             oldCoord.latitude, oldCoord.longitude,
                             newCoord.latitude, newCoord.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
}

- (void) showLoadingOverlay {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    overlayView.frame = map.frame;
    activityView.center = map.center;
    [self.view addSubview:overlayView];
    [self.view addSubview:activityView];
    [activityView startAnimating];
}

- (void) hideLoadingOverlay {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [overlayView removeFromSuperview];
    [activityView removeFromSuperview];
}


- (void) generateRandomLocation {
    [self showLoadingOverlay];
    
    [locationController randomLocationNear:map.region.center
                             latitudeRange:map.region.span.latitudeDelta/2
                            longitudeRange:map.region.span.longitudeDelta/2
                                  complete:^(Quest *location) {
                                      if (self.visibleQuest)
                                          [map removeAnnotation:self.visibleQuest];
                                      
                                      if (location) {                    
                                          [map addAnnotation:location];
                                          self.visibleQuest = location;
                                      }
                                      
                                      [map setCenterCoordinate:[self.visibleQuest coordinate] animated:YES];
                                      [map selectAnnotation:self.visibleQuest animated:NO];
                                      [self hideLoadingOverlay];
                                  }];        
}

- (void) didTapRandom {
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
            
            self.userLocation = loc;
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
    
    [infoView removeFromSuperview];
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
