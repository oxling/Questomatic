

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

@implementation ViewController
@synthesize map, currentPoint, userLocation;

BOOL fireActivityTimer;

- (void) initVariables { 
    locationController = [[LocationController alloc] init];
    shakeView = [[ShakeView alloc] initWithFrame:CGRectMake(0, 0, 176, 126)];
    shakeView.center = self.view.center;
    shakeView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    
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
    
    [super dealloc];
}

#pragma mark - Actions

- (void) activityOccured {
    if (fireActivityTimer) {
        [actionTimer invalidate];
        actionTimer = nil;
    
        [shakeView animateRemoveFromSuperView];
        actionTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(noActivity) userInfo:nil repeats:NO];
    }
}

- (void) noActivity {
    [actionTimer invalidate];
    actionTimer = nil;
    
    [shakeView animateAddToSuperView:self.view];
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) {
        [self didTapRandom:nil];
        [self activityOccured];
    }
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

#pragma mark - Map

QuestCalloutView * c;

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    [self activityOccured];
}

- (void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    [self activityOccured];
    
}

- (void) mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [self activityOccured];
    [c removeFromSuperview];
}

- (id) randomItem:(NSArray *) array {
    int indx = rand() % [array count];
    
    NSAssert(indx < [array count], @"Random index out of bounds");
    
    return [array objectAtIndex:indx];
}

- (NSString *) verbForType:(NSString *)type {
    
    if ([type isEqualToString:@"grocery_or_supermarket"]) {
        return @"buy a snack at";
    }
    
    if ([type isEqualToString:@"cafe"]) {
        return @"drink coffee at";
    }
    
    if ([type isEqualToString:@"restaurant"] ||
        [type isEqualToString:@"bakery"]) {
        
        return @"eat at";
    }
    
    if ([type isEqualToString:@"library"]) {
        return @"read a book at";
    }
    
    if ([type isEqualToString:@"bar"] ||
        [type isEqualToString:@"night_club"]) {
        return @"drink at";
    }
    
    if ([type isEqualToString:@"store"]) {
        return [self randomItem:[NSArray arrayWithObjects:@"shop at", @"buy something at", @"browse", nil]];
    }
        
    if ([type isEqualToString:@"gym"]) {
        return @"work out at";
    }
    
    if ([type isEqualToString:@"salon"]) {
        return @"get a haircut at";
    }
    
    if ([type isEqualToString:@"movie_theater"]) {
        return @"see a movie at";
    }
    
    if ([type isEqualToString:@"natural_feature"] ||
        [type isEqualToString:@"point_of_interest"]) {
        return [self randomItem:[NSArray arrayWithObjects:@"see", @"take a picture of", @"admire", nil]];
    }
    
    if ([type isEqualToString:@"water"]) {
        return [self randomItem:[NSArray arrayWithObjects:@"swim in the", @"sail on the", @"fish in the", @"drink from the", nil]];
    }
    
    if ([type isEqualToString:@"spa"]) {
        return @"relax at";
    }
    
    else return nil;
}

- (NSString *) getVerbForQuest:(Quest *)q {
    NSString * verb = @"visit";
    for (NSString * type in q.types) {
        NSString * newVerb = [self verbForType:type];
        if (newVerb) {
            verb = newVerb;
            break;
        }
    }
    
    return verb;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (annotation == self.currentPoint) {
        static NSString * const identifer = @"mapview_id_quest";
        QuestCalloutView * pin = (QuestCalloutView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifer];
        if (!pin) {
            pin = [[[QuestCalloutView alloc] initWithAnnotation:annotation reuseIdentifier:identifer] autorelease];
        }
        
        pin.annotation = annotation;
        pin.title = [annotation title];
        pin.subtitle = [annotation subtitle];
        pin.questString = [self getVerbForQuest:(Quest *)annotation];
        pin.htmlString = [(Quest *)annotation listings];
        
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
