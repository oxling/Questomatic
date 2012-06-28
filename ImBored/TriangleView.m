//
//  TriangleView.m
//  ImBored
//
//  Created by Amy Dyer on 4/8/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "TriangleView.h"

enum {
    TriangleStyleLeft,
    TriangleStyleRight
};

@interface TriangleView () {
@private
    int _style;
}
@end

@implementation TriangleView

- (id) initWithStyle:(int)style {
    NSAssert(style == TriangleStyleLeft || style == TriangleStyleRight, @"Invalid TriangleView style: %i", style);
        
    self = [super initWithFrame:CGRectMake(0, 0, 19, 17)];
    if (self) {
        [self setOpaque:NO];
        _style = style;
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    return [self initWithStyle:TriangleStyleRight];
}

+ (TriangleView *) leftTriangle {
    return [[[TriangleView alloc] initWithStyle:TriangleStyleLeft] autorelease];
}

+ (TriangleView *) rightTriangle {
    return [[[TriangleView alloc] initWithStyle:TriangleStyleRight] autorelease];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect frame = CGRectInset(self.bounds, 2, 2);
    
    UIGraphicsPushContext(ctx);
    
    if (_style == TriangleStyleLeft) {
        CGContextScaleCTM(ctx, -1, 1);
        CGContextTranslateCTM(ctx, -CGRectGetWidth(self.frame), 0);
    }
    
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 1.0, [[UIColor blackColor] CGColor]);
    
    CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
    
    CGContextMoveToPoint(ctx, CGRectGetMinX(frame), CGRectGetMinY(frame));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(frame), CGRectGetMidY(frame));
    CGContextAddLineToPoint(ctx, CGRectGetMinX(frame), CGRectGetMaxY(frame));
    CGContextAddLineToPoint(ctx, CGRectGetMinX(frame), CGRectGetMinY(frame));
    
    CGContextFillPath(ctx);

    
    UIGraphicsPopContext();
}

@end
