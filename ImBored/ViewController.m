

//
//  ViewController.m
//  ImBored
//
//  Created by Amy Dyer on 1/21/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AddressBook/ABPerson.h>

#import "MapAPIController.h"
#import "LocationController.h"
#import "QuestCalloutView.h"
#import "QuestDetailView.h"
#import "DetailViewController.h"
#import "TriangleView.h"

@implementation ViewController
@synthesize map, visibleQuest, userLocation, acceptedQuest;

BOOL fireActivityTimer = NO;

#pragma mark - Init and Memory

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

/* The activity timer generates the nag message telling the user to shake their iPhone
 if they haven't done anything in at least 30 seconds. */

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

//Look for phone shakes
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

- (void) displayActiveQuest {
    if (acceptedQuest) {
        [self.view addSubview:detailView];
        [detailView setQuest:[NSString stringWithFormat:@"Your quest is to %@", [acceptedQuest getVerb]] withTitle:acceptedQuest.title];
        [detailView setShowsRightTriangle:YES];
    } else {
        [detailView removeFromSuperview];
    }
}

- (void) setAcceptedQuest:(Quest *)newAcceptedQuest {
    if (newAcceptedQuest == acceptedQuest)
        return;
    
    [acceptedQuest release];
    acceptedQuest = [newAcceptedQuest retain];
    
    [self displayActiveQuest];
}

- (void) didAcceptQuest:(id)quest inView:(QuestCalloutView *)view {
    NSAssert([quest isKindOfClass:[Quest class]], @"Annotation %@ must be of class Quest", quest);
    
    self.acceptedQuest = quest;
    view.acceptButton.enabled = NO;
    [view updateButtonStyle:NO];
}

- (void) didTapCurrentQuest:(UITapGestureRecognizer *)tapper {
    DetailViewController * detailVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    detailVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    detailVC.quest = self.acceptedQuest;
    [self presentModalViewController:detailVC animated:YES];
    [detailVC release];
}

- (void) didTapCalloutView:(QuestCalloutView *)view {
    [map deselectAnnotation:view.annotation animated:YES];
}

- (void) didCancelQuest {
    self.acceptedQuest = nil;
}

#pragma mark - MapView delegate methods

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
        
        NSAssert([annotation isKindOfClass:[Quest class]], @"Set a non-quest annotation: %@", annotation);
        Quest * q = (Quest *)annotation;
        
        pin.annotation = annotation;
        pin.title = q.title;
        pin.subtitle = q.subtitle;
        pin.questString = [UtilityKit capitalizeString:[q getVerb]];
        pin.htmlString = [q listings];
        pin.delegate = self;
        
        if (q != acceptedQuest) {
            pin.acceptButton.enabled = YES;
            [pin updateButtonStyle:YES];
        } else {
            pin.acceptButton.enabled = NO;
            [pin updateButtonStyle:NO];
        }
        
        [pin updateButtonStyle:YES];
        
        [pin updateFrameAndLabels];
        
        return pin;
    } else return nil;
}

#pragma mark - Loading

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

#pragma mark - Locations

- (void) generateRandomLocation {
    [self showLoadingOverlay];
    
    [locationController randomLocationNear:map.region.center
                             latitudeRange:map.region.span.latitudeDelta/3
                            longitudeRange:map.region.span.longitudeDelta/3
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

- (void) zoomToUserLocation {
    
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
            CLLocationCoordinate2D coord =  CLLocationCoordinate2DMake(42.378075, -71.044464); //Boston!
            MKCoordinateSpan span = MKCoordinateSpanMake(0.20, 0.20);
            [map setRegion:MKCoordinateRegionMake(coord, span) animated:YES];
            
            [[[[UIAlertView alloc] initWithTitle:@"GPS Problem" message:@"Unable to find your coordinates. Zoom in where you would like to search for a quest." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
            
            fireActivityTimer = YES;
        }
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

- (void) viewDidLoad {
    [super viewDidLoad];
        
    infoView = [[InfoView alloc] initWithFrame:CGRectMake(0, 0, 176, 126)];
    infoView.center = self.view.center;
    infoView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    detailView = [[QuestDetailView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    detailView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UITapGestureRecognizer * tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapCurrentQuest:)];
    [detailView addGestureRecognizer:tapper];
    [tapper release];
    
    overlayView = [[UIView alloc] initWithFrame:self.view.frame];
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    overlayView.backgroundColor = [UIColor blackColor];
    overlayView.alpha = 0.45;
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = overlayView.center;
    activityView.frame = [UtilityKit roundFrame:activityView.frame];
    activityView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    if (acceptedQuest) {
        //There will be an accepted quest if the view was unloaded
        map.centerCoordinate = acceptedQuest.coordinate;
        MKCoordinateSpan span = MKCoordinateSpanMake(0.03, 0.03);
        [map setRegion:MKCoordinateRegionMake(acceptedQuest.coordinate, span) animated:NO];
        [map addAnnotation:acceptedQuest];

        [self displayActiveQuest];
    } else {
        [self zoomToUserLocation];
    }
}

- (void) viewDidUnload {
    [super viewDidUnload];
    
    [infoView removeFromSuperview];
    [infoView release];
    infoView = nil;
    
    [detailView removeFromSuperview];
    [detailView release];
    detailView = nil;
    
    [overlayView removeFromSuperview];
    [overlayView release];
    overlayView = nil;
    
    [activityView removeFromSuperview];
    [activityView release];
    activityView = nil;
}

@end
