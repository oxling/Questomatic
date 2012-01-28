//
//  QuestDetailView.m
//  ImBored
//
//  Created by Amy Dyer on 1/28/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "QuestDetailView.h"
#import <QuartzCore/QuartzCore.h>

@interface DetailLayerDelegate : NSObject
@end

@implementation DetailLayerDelegate

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    const CGFloat gradCompsBlue[8] = {0.3, 0.40, 0.50, 1.0, 
        0.10,  0.20, 0.35, 1.0};
    const CGFloat gradLocs[2] = {1.0, 0.0};
    const CGFloat gradCompsWhite[8] = {1.0, 1.0, 1.0, 0.25,
        1.0, 1.0, 1.0, 0.15};
    
    CGColorSpaceRef cspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef grad1 = CGGradientCreateWithColorComponents(cspace, gradCompsBlue, gradLocs, 2);
    CGGradientRef grad2 = CGGradientCreateWithColorComponents(cspace, gradCompsWhite, gradLocs, 2);
    
    CGContextDrawLinearGradient(ctx, grad1, 
                                CGPointMake(CGRectGetMidX(layer.frame), 0), 
                                CGPointMake(CGRectGetMidX(layer.frame), CGRectGetMaxY(layer.frame)),
                                NULL);
    
    CGContextClipToRect(ctx, CGRectMake(0, 0, CGRectGetWidth(layer.frame), CGRectGetMidY(layer.frame)));
    
    CGContextDrawLinearGradient(ctx, grad2, 
                                CGPointMake(CGRectGetMidX(layer.frame), 0), 
                                CGPointMake(CGRectGetMidX(layer.frame), CGRectGetMaxY(layer.frame)),
                                NULL);

    CGColorSpaceRelease(cspace);
    CGGradientRelease(grad1);
    CGGradientRelease(grad2);
}

@end

@implementation QuestDetailView
DetailLayerDelegate * del;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        del = [[DetailLayerDelegate alloc] init];
        backgroundLayer = [[CALayer layer] retain];
        backgroundLayer.delegate = del;
        
        [self.layer addSublayer:backgroundLayer];
    }
    return self;
}

- (void) dealloc {
    [del release];
    [backgroundLayer release];
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
    [backgroundLayer setNeedsDisplay];
}

@end
