//
//  QuestAnnotationView.h
//  ImBored
//
//  Created by Amy Dyer on 1/22/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import <MapKit/MapKit.h>

@class LocationCalloutView;
@interface QuestAnnotationView : MKAnnotationView {
    LocationCalloutView * callout;
}

@end
