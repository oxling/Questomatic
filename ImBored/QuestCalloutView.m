//
//  LocationCalloutView.m
//  ImBored
//
//  Created by Amy Dyer on 1/22/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "QuestCalloutView.h"
#import <QuartzCore/QuartzCore.h>

#define CARAT_SIZE 20
#define OFFSET 5
#define RADIUS 10

@interface LayerDelegate : NSObject
@end

@implementation LayerDelegate

- (void)arcPath:(CGMutablePathRef)path aroundCorner:(CGPoint)corner toPoint:(CGPoint)point {
    CGPathAddArcToPoint(path, NULL, corner.x, corner.y, point.x, point.y, RADIUS);
}

- (void) line:(CGMutablePathRef)path toPoint:(CGPoint)point {
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    
    CGContextSaveGState(ctx);
    
    CGMutablePathRef p = CGPathCreateMutable();
    CGRect frame = layer.frame;
    
    CGPoint bottomTip = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame));
    CGPoint leftTip = CGPointMake(bottomTip.x - (CARAT_SIZE/2), bottomTip.y-CARAT_SIZE);
    CGPoint rightTip = CGPointMake(bottomTip.x + (CARAT_SIZE/2), bottomTip.y-CARAT_SIZE);
    
    CGPoint brCorner = CGPointMake(CGRectGetMaxX(frame)-OFFSET, CGRectGetMaxY(frame)-CARAT_SIZE);
    CGPoint trCorner = CGPointMake(CGRectGetMaxX(frame)-OFFSET, CGRectGetMinY(frame)+OFFSET);
    CGPoint tlCorner = CGPointMake(CGRectGetMinX(frame)+OFFSET, CGRectGetMinY(frame)+OFFSET);
    CGPoint blCorner = CGPointMake(CGRectGetMinX(frame)+OFFSET, CGRectGetMaxY(frame)-CARAT_SIZE);
    
    CGPathMoveToPoint(p, NULL, tlCorner.x, tlCorner.y+RADIUS);
    [self arcPath:p aroundCorner:tlCorner toPoint:CGPointMake(tlCorner.x+RADIUS, tlCorner.y)];
    [self line:p toPoint:CGPointMake(trCorner.x-RADIUS, trCorner.y)];
    [self arcPath:p aroundCorner:trCorner toPoint:CGPointMake(trCorner.x, trCorner.y+RADIUS)];
    [self line:p toPoint:CGPointMake(brCorner.x, brCorner.y-RADIUS)];
    [self arcPath:p aroundCorner:brCorner toPoint:CGPointMake(brCorner.x-RADIUS, brCorner.y)];
    
    [self line:p toPoint:rightTip];
    [self line:p toPoint:bottomTip];
    [self line:p toPoint:leftTip];
    
    [self line:p toPoint:CGPointMake(blCorner.x+RADIUS, blCorner.y)];
    [self arcPath:p aroundCorner:blCorner toPoint:CGPointMake(blCorner.x, blCorner.y-RADIUS)];
    [self line:p toPoint:CGPointMake(tlCorner.x, tlCorner.y+RADIUS)];
    
    CGPathCloseSubpath(p);

    const CGFloat gradCompsBlue[8] = {0.3, 0.40, 0.50, 1.0, 
                                      0.10,  0.20, 0.35, 1.0};
    const CGFloat gradLocs[2] = {1.0, 0.0};
    const CGFloat gradCompsWhite[8] = {1.0, 1.0, 1.0, 0.25,
                                       1.0, 1.0, 1.0, 0.15};
    
    CGColorSpaceRef cspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef grad1 = CGGradientCreateWithColorComponents(cspace, gradCompsBlue, gradLocs, 2);
    CGGradientRef grad2 = CGGradientCreateWithColorComponents(cspace, gradCompsWhite, gradLocs, 2);
    
    CGFloat shineWidth = CGRectGetWidth(frame)*1.5;
    CGFloat shineHeight = CGRectGetHeight(frame);
    CGFloat shineX = CGRectGetMidX(frame) - shineWidth/2;
    CGFloat shineY = -shineHeight/2;
    
    CGRect shineRect = CGRectMake(shineX, shineY, shineWidth, shineHeight);
    CGPathRef shinePath = CGPathCreateWithEllipseInRect(shineRect, NULL);
    CGContextSetShadowWithColor(ctx, CGSizeMake(1.0, 1.0), 5.0, [[UIColor blackColor] CGColor]);
    
    CGContextBeginTransparencyLayer(ctx, NULL);
    
    CGContextAddPath(ctx, p);
    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx, grad1, CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame)), bottomTip, 0);
    CGContextAddPath(ctx, shinePath);
    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx, grad2, CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame)), 
                                CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame)), 0);
    
    CGContextEndTransparencyLayer(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
    CGContextSetShadowWithColor(ctx, CGSizeMake(0.0, 0.0), 1.0, [[UIColor blackColor] CGColor]);
    CGContextSetLineWidth(ctx, 1.5);
    CGContextAddPath(ctx, p);
    CGContextStrokePath(ctx);
    
    CGPathRelease(shinePath);
    CGPathRelease(p);
    CGColorSpaceRelease(cspace);
    CGGradientRelease(grad1);
    CGGradientRelease(grad2);
    
    CGContextRestoreGState(ctx);
}


@end

@implementation QuestCalloutView
@synthesize subtitle, title, questString, htmlString;
LayerDelegate * del;

- (void) initVariables:(CGRect)frame {
    del = [[LayerDelegate alloc] init];
    
    backgroundLayer = [[CALayer layer] retain];
    backgroundLayer.frame = frame;
    backgroundLayer.delegate = del;
    
    [self.layer addSublayer:backgroundLayer];
    
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat left = CGRectGetMinX(frame)+OFFSET+5;
    CGFloat width = CGRectGetMaxX(frame)-OFFSET*2-10;
    
    questLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 17)];
    questLabel.backgroundColor = [UIColor clearColor];
    questLabel.numberOfLines = 0;
    questLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    questLabel.textColor = [UIColor whiteColor];
    questLabel.shadowOffset = CGSizeMake(1, 1);
    questLabel.shadowColor = [UIColor darkGrayColor];
    questLabel.textAlignment = UITextAlignmentCenter;
    questLabel.text = @"Your quest is to visit";
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(questLabel.frame), width, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.shadowColor = [UIColor darkGrayColor];
    titleLabel.shadowOffset = CGSizeMake(1, 1);
    
    subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), width, 17)];
    subtitleLabel.backgroundColor = [UIColor clearColor];
    subtitleLabel.numberOfLines = 0;
    subtitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    subtitleLabel.textColor = [UIColor whiteColor];
    subtitleLabel.shadowOffset = CGSizeMake(1, 1);
    subtitleLabel.shadowColor = [UIColor darkGrayColor];
    subtitleLabel.textAlignment = UITextAlignmentCenter;
    
    CGFloat containerHeight = questLabel.frame.size.height+titleLabel.frame.size.height+subtitleLabel.frame.size.height;
    
    labelContainer = [[UIView alloc] initWithFrame:CGRectMake(left, OFFSET+5, width, containerHeight)];
    labelContainer.backgroundColor = [UIColor clearColor];
    [self addSubview:labelContainer];
    
    [labelContainer addSubview:subtitleLabel];
    [labelContainer addSubview:titleLabel];
    [labelContainer addSubview:questLabel];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 200, frame.size.height)];
    if (self) {
        [self initVariables:frame];
    }
    return self;
}

- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 200, 120);
        [self initVariables:self.frame];
    }
    return self;
}

- (void) updateFrameAndLabels {
    CGFloat width = 200-OFFSET*2-10;
        
    CGSize questSize = [questLabel.text sizeWithFont:questLabel.font constrainedToSize:CGSizeMake(width, 30)
                                       lineBreakMode:UILineBreakModeWordWrap];
    
    CGSize titleSize = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(width, 50) 
                                       lineBreakMode:UILineBreakModeWordWrap];
    
    CGSize subtitleSize = [subtitleLabel.text sizeWithFont:subtitleLabel.font constrainedToSize:CGSizeMake(width, 30) 
                                             lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat htmlSize = htmlView ? 18 : 0;
    
    CGFloat contentSize = subtitleSize.height + questSize.height + titleSize.height + htmlSize + 50 - OFFSET*2;
    
    CGRect contentRect = CGRectMake(OFFSET, OFFSET, 200-OFFSET*2, contentSize);
    
    labelContainer.frame = CGRectMake(0, 0, width, questSize.height+titleSize.height+subtitleSize.height);
    labelContainer.center = CGPointMake(roundf(CGRectGetMidX(contentRect)), roundf(CGRectGetMidY(contentRect)));
    
    questLabel.frame = CGRectMake(0, 0, width, questSize.height);
    titleLabel.frame = CGRectMake(0, CGRectGetMaxY(questLabel.frame), width, titleSize.height);
    subtitleLabel.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame), width, subtitleSize.height);
    
    htmlView.frame = CGRectMake(OFFSET+5, CGRectGetMaxY(contentRect)-htmlSize, width, htmlSize);
    
    self.frame = CGRectMake(0, 0, 200, CGRectGetHeight(contentRect) + CARAT_SIZE + OFFSET*2);
}

- (CGFloat) contentHeight {
    return questLabel.frame.size.height + titleLabel.frame.size.height + subtitleLabel.frame.size.height;
}

- (void) setQuestString:(NSString *)newQuestString {
    questLabel.text = [NSString stringWithFormat:@"Your quest is to %@", newQuestString];
}

- (void) setTitle:(NSString *)newTitle {
    titleLabel.text = newTitle;
}

- (void) setSubtitle:(NSString *)newSubtitle {
    subtitleLabel.text = newSubtitle;
}

- (void) setHtmlString:(NSString *)newHtmlString {
    
    if (newHtmlString) {
        
        [newHtmlString retain];
        [htmlString release];
        htmlString = newHtmlString;
        
        if (!htmlView) {
            htmlView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            htmlView.backgroundColor = [UIColor clearColor];
            htmlView.opaque = NO; 
            htmlView.delegate = self;
            htmlView.scrollView.scrollEnabled = NO;
            htmlView.scalesPageToFit = YES;
            
            [self addSubview:htmlView];
        }
        
        [htmlView loadHTMLString:htmlString baseURL:nil];
    } else {
        [htmlString release];
        htmlString = nil;
        
        [htmlView removeFromSuperview];
        [htmlView release];
        htmlView = nil;
    }
    
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    return YES;
}

- (NSString *) questString {
    return questLabel.text;
}

- (NSString *) title {
    return titleLabel.text;
}

- (NSString *) subtitle {
    return subtitleLabel.text;
}

- (CGPoint) centerOffset {
    return CGPointMake(0, -roundf(self.frame.size.height/2));
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    backgroundLayer.frame = frame;
    
    [self setNeedsDisplay];
}

- (void) dealloc {
    [del release];
    [backgroundLayer release];
    [subtitleLabel release];
    [titleLabel release];
    [questLabel release];
    [labelContainer release];
    [htmlString release];
    [htmlView release];
    
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
    [backgroundLayer setNeedsDisplay];
}


@end
