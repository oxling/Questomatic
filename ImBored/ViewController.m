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

#import "MapAPIController.h"

@interface ViewController () {
@private
    CLLocationManager * locMan;
    CLLocation * loc;
    
    MapAPIController * mapController;
}

@end

@implementation ViewController
@synthesize map, button, lastPoint;

- (void) initVariables { 
    locMan = [[CLLocationManager alloc] init];
    locMan.delegate = self;
    
    mapController = [[MapAPIController alloc] init];
    
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
    [locMan release];
    [button release];
    [map release];
    [mapController release];
    [lastPoint release];
    
    [super dealloc];
}

static float randomFraction() {
    signed int r = rand() % 100;
    int neg = rand() % 2;
    
    float frac = ((float) r)/100;
    if (neg) frac *= -1;
    
    return frac;
}

- (CLLocation *) offsetLocation {
    CLLocationCoordinate2D x = loc.coordinate;
    
    MKCoordinateRegion rect = map.region;    

    float latDiff =  randomFraction() * (rect.span.latitudeDelta/2);
    float longDiff = randomFraction() * (rect.span.longitudeDelta/2);
    
    CLLocation * new = [[CLLocation alloc] initWithLatitude:x.latitude+latDiff longitude:x.longitude+longDiff];
    return [new autorelease];
}

- (void) centerMap {
    map.region = MKCoordinateRegionMake(loc.coordinate, MKCoordinateSpanMake(0.02, 0.02));
    map.showsUserLocation = YES;
}

int failCount = 0;

- (void) generateRandomLocation {
    
    CLLocation * newLoc = [self offsetLocation];
    
    [mapController requestNearLocation:newLoc onComplete:^(id <MKAnnotation> location) {
        if (location) {
            failCount = 0;
            
            if (self.lastPoint) [map removeAnnotation:self.lastPoint];
           
            [map addAnnotation:location];
            self.lastPoint = location;
        } else {
            if (failCount < 5) {
                failCount++;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self generateRandomLocation];
                });
            } else {
                failCount = 0;
            }
        }
        
        button.enabled = YES;
    }]; 
}

- (void) didTapRandom:(id)sender {
  //  button.enabled = NO;
    [self generateRandomLocation];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    loc = [newLocation retain];
    [self centerMap];
    
    [locMan stopUpdatingLocation];
    [locMan release];
    locMan = nil;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [locMan startUpdatingLocation];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    [locMan stopUpdatingLocation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
