//
//  QuestDetailView.m
//  ImBored
//
//  Created by Amy Dyer on 1/28/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import "QuestDetailView.h"
#import <QuartzCore/QuartzCore.h>

#define SHADOWSPACE 6

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

- (void) initVariablesWithFrame:(CGRect)frame {
    del = [[DetailLayerDelegate alloc] init];
    
    backgroundLayer = [[CALayer layer] retain];
    backgroundLayer.delegate = del;
    backgroundLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height-SHADOWSPACE);
    backgroundLayer.shadowColor = [[UIColor blackColor] CGColor];
    backgroundLayer.shadowOpacity = 1.0;
    backgroundLayer.shadowOffset = CGSizeMake(0, 2);
    backgroundLayer.shadowRadius = 3.0;
    [backgroundLayer setContentsScale:[self contentScaleFactor]];
    
    [self.layer addSublayer:backgroundLayer];
    self.backgroundColor = [UIColor clearColor];
    
    questLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, frame.size.width-10, 17)];
    questLabel.backgroundColor = [UIColor clearColor];
    questLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    questLabel.textColor = [UIColor whiteColor];
    questLabel.textAlignment = UITextAlignmentCenter;
    questLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 18, frame.size.width-10, frame.size.height-17)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initVariablesWithFrame:frame];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initVariablesWithFrame:CGRectZero];
    }
    return self;
}

- (void) dealloc {
    [backgroundLayer release];
    [del release];
    
    [questLabel release];
    [titleLabel release];
    [super dealloc];
}

- (void) updateFrameWithWidth:(CGFloat)width {
    CGSize titleSize = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(width-30, 200) lineBreakMode:UILineBreakModeWordWrap];
    
    CGRect frame = CGRectMake(0, 0, width, titleSize.height+17+SHADOWSPACE);
    [super setFrame:frame];
    [backgroundLayer setFrame:frame];
    [self setNeedsDisplay];
    
    titleLabel.frame = CGRectMake(15, 18, width-30, titleSize.height);
    questLabel.frame = CGRectMake(5, 0, frame.size.width-10, 17);
    
    [self addSubview:titleLabel];
    [self addSubview:questLabel];
}

- (void)drawRect:(CGRect)rect {
    [backgroundLayer setNeedsDisplay];
}

- (void) setFrame:(CGRect)frame {
    [self updateFrameWithWidth:frame.size.width];
}

- (void) setQuest:(NSString *)questString withTitle:(NSString *)titleString {
    CATransition * anim = [CATransition animation];
    [anim setType:kCATransitionMoveIn];
    [anim setSubtype:kCATransitionFromBottom];
    
    questLabel.text = questString;
    titleLabel.text = titleString;
    [self updateFrameWithWidth:self.frame.size.width];
    
    [self.layer addAnimation:anim forKey:@"pushanimation"];
}

@end
