//
//  ViewController.m
//  ImBored
//
//  Created by Amy Dyer on 1/21/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () {
@private
    CLLocationManager * locMan;
    CLLocation * loc;
    
    
}

@end

@implementation ViewController

- (void) initVariables { 
    locMan = [[CLLocationManager alloc] init];
    locMan.delegate = self;
    
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
    [super dealloc];
}

- (void) logReverseLocation:(CLLocation *)newLocation {
    CLGeocoder * g = [[CLGeocoder alloc] init];
    [g reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * p in placemarks) {
            NSLog(@"%@", [p description]);
        }
    }];
    [g release];
    
}

static float randomFraction() {
    signed int r = rand() % 100;
    int neg = rand() % 1;
    float frac = ((float) r)/100;
    if (neg) frac *= -1;
    
    return frac;
}

- (void) offsetLocation {
    CLLocationCoordinate2D x = loc.coordinate;

    float latDiff =  randomFraction() * 0.01;
    float longDiff = randomFraction() * 0.01;
    
    CLLocation * new = [[CLLocation alloc] initWithLatitude:x.latitude+latDiff longitude:x.longitude+longDiff];
    [self logReverseLocation:new];
    [new release];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLGeocoder * g = [[CLGeocoder alloc] init];
    [g reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * p in placemarks) {
            loc = [p.location retain];
            [self offsetLocation];
        }
    }];
    [g release];
    
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
