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
                                0);
    
    CGFloat ellipseWidth = CGRectGetWidth(layer.frame)*1.5;
    CGRect ellipseRect = CGRectMake(CGRectGetMidX(layer.frame) - ellipseWidth/2, 
                                    -CGRectGetHeight(layer.frame)/2+10, 
                                    ellipseWidth, 
                                    CGRectGetHeight(layer.frame));
    
    CGContextSaveGState(ctx);
    
    CGContextAddEllipseInRect(ctx, ellipseRect);
    CGContextClip(ctx);
    
    CGContextDrawLinearGradient(ctx, grad2, 
                                CGPointMake(CGRectGetMidX(layer.frame), 0), 
                                CGPointMake(CGRectGetMidX(layer.frame), CGRectGetMaxY(layer.frame)),
                                0);
    
    CGContextRestoreGState(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
    CGContextSetShadowWithColor(ctx, CGSizeMake(0.0, 0.0), 1.0, [[UIColor blackColor] CGColor]);
    CGContextSetLineWidth(ctx, 2.0);
    CGContextMoveToPoint(ctx, 0, CGRectGetMaxY(layer.frame)-1.5);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(layer.frame), CGRectGetMaxY(layer.frame)-1.5);
    CGContextStrokePath(ctx);

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
        backgroundLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height-6);
        backgroundLayer.shadowColor = [[UIColor blackColor] CGColor];
        backgroundLayer.shadowOpacity = 1.0;
        backgroundLayer.shadowOffset = CGSizeMake(0, 2);
        backgroundLayer.shadowRadius = 3.0;
        
        [self.layer addSublayer:backgroundLayer];
        
        self.backgroundColor = [UIColor clearColor];
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

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [backgroundLayer setFrame:frame];
    [self setNeedsDisplay];
}

@end
