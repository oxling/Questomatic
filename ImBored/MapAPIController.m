//
//  MapAPIController.m
//  ImBored
//
//  Created by Amy Dyer on 1/21/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import "MapAPIController.h"
#import <CoreLocation/CoreLocation.h>
#import "MapAPIResultParser.h"

@implementation MapAPIController
@synthesize connection, block, data;

- (NSURL *) requestURLForLocation:(CLLocation *)location {
    static const NSString * baseURL = @"https://maps.googleapis.com/maps/api/place/search/xml?radius=1000&sensor=true&key=AIzaSyD7U3eAt0K7XFSXiLS2h_z5J4KoAJSKstE&types=amusement_park%7Caquarium%7Cart_gallery%7Cbakery%7Cbar%7Cbeauty_salon%7Cbicycle_store%7Cbook_store%7Cbowling_alley%7Ccafe%7Ccampground%7Ccar_wash%7Ccasino%7Ccemetery%7Cchurch%7Ccity_hall%7Cclothing_store%7Cconvenience_store%7Cdepartment_store%7Celectronics_store%7Cembassy%7Cfire_station%7Cflorist%7Cfood%7Cfuneral_home%7Cfurniture_store%7Cgeocode%7Cgrocery_or_supermarket%7Cgym%7Chair_care%7Chardware_store%7Chindu_temple%7Chome_goods_store%7Chospital%7Cjewelry_store%7Clibrary%7Cliquor_store%7Clocal_government_office%7Clocksmith%7Clodging%7Cmeal_delivery%7Cmeal_takeaway%7Cmosque%7Cmovie_rental%7Cmovie_theater%7Cmuseum%7Cnight_club%7Cpainter%7Cpark%7Cpet_store%7Cplace_of_worship%7Crestaurant%7Crv_park%7Cshoe_store%7Cshopping_mall%7Cspa%7Cstadium%7Cstore%7Csynagogue%7Ctrain_station%7Ctravel_agency%7Cuniversity%7Czoo%7Cpoint_of_interest%7Cnatural_feature";
    
    CLLocationCoordinate2D coord = location.coordinate;
    
    NSString * finalStr = [baseURL stringByAppendingFormat:@"&location=%f,%f", coord.latitude, coord.longitude];
    return [NSURL URLWithString:finalStr];
}


- (void) requestNearLocation:(CLLocation *)location onComplete:(CompleteBlock)complete {
    
    if (connection == nil) {
        self.block = complete;
        self.connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[self requestURLForLocation:location]] delegate:self];
        
        if (connection) {
            self.data = [[[NSMutableData alloc] init] autorelease];
        }
    } else {
        DebugLog(@"Request is already in progress. Ignoring new request %@", [location description]);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)newData {
    [data appendData:newData];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    block(nil);
    
    self.block = nil;
    self.data = nil;
    self.connection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    MapAPIResultParser * p = [[MapAPIResultParser alloc] init];

    NSArray * places = [p parseResults:data];
    if ([places count] > 0) {
        int indx = rand() % [places count];
        block([places objectAtIndex:indx]);
    } else {
        block(nil);
    }
    
    [p release];

    self.block = nil;
    self.data = nil;
    self.connection = nil;
}

- (void) dealloc {
    [data release];
    [block release];
    [connection release];
    [super dealloc];
}


@end
