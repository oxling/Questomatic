//
//  ShakeView.m
//  ImBored
//
//  Created by Amy Dyer on 1/22/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "ShakeView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ShakeView

- (NSString *) labelString {
    NSString * device = [[UIDevice currentDevice] model];
    return [NSString stringWithFormat:@"Shake your %@ to find a new adventure on the map", device];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect insetRect = CGRectInset(frame, 5, 5);
        UIColor * color = [UIColor colorWithWhite:0.1 alpha:1.0];
        
        label = [[UILabel alloc] initWithFrame:CGRectInset(insetRect, 10, 5)];
        [self addSubview:label];
        
        label.backgroundColor = color;
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        label.text = [self labelString];
        label.layer.cornerRadius = 10.0;
        
        self.alpha = 0.0;
    }
    return self;
}

- (void) animateAddToSuperView:(UIView *)view {
    self.alpha = 0.0;
    [view addSubview:self];

    [UIView animateWithDuration:0.75 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        //
    }];
}

- (void) animateRemoveFromSuperView {
    [UIView animateWithDuration:0.75 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void) dealloc {
    [label release];
    [backgroundLayer release];
    
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
