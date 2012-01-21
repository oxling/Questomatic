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
    CLGeocoder * coder;
}

@end

@implementation ViewController
@synthesize map, button, lastPoint;

- (void) initVariables { 
    locMan = [[CLLocationManager alloc] init];
    locMan.delegate = self;
    
    mapController = [[MapAPIController alloc] init];
    coder = [[CLGeocoder alloc] init];
    
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
    [coder release];
    
    [super dealloc];
}

static float randomFraction() {
    signed int r = rand() % 100;
    int neg = rand() % 2;
    
    float frac = ((float) r)/100;
    if (neg) frac *= -1;
    
    return frac;
}

- (void) isValid:(CLLocation *)location complete:(void (^)(BOOL valid, CLPlacemark *p))block  {
    [coder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        BOOL inTheGoddamnOcean = NO;
        for (CLPlacemark * p in placemarks) {
            if (p.inlandWater || p.ocean) {
                inTheGoddamnOcean = YES;
                break;
            }
        }
        
        block(!inTheGoddamnOcean, [placemarks objectAtIndex:0]);
    }];
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

- (void) generateRandomLocation {
    
    CLLocation * newLoc = [self offsetLocation];
    
    [self isValid:newLoc complete:^(BOOL valid, CLPlacemark * p) {
        if (valid) {
            [mapController requestNearLocation:newLoc onComplete:^(id <MKAnnotation> location) {
                if (self.lastPoint)
                    [map removeAnnotation:self.lastPoint];
                
                if (location) {                    
                    [map addAnnotation:location];
                    self.lastPoint = location;
                } else {
                    MKPlacemark * pm = [[MKPlacemark alloc] initWithPlacemark:p];
                    [map addAnnotation:pm];
                    self.lastPoint = pm;
                    [pm release];
                }
                
                button.enabled = YES;
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }]; 
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self generateRandomLocation];
            });
        }
    }];
}

- (void) didTapRandom:(id)sender {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    button.enabled = NO;
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
