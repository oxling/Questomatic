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
    return [NSString stringWithFormat:@"Shake your %@ to find a new quest on the map", device];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIColor * color = [UIColor colorWithWhite:0.1 alpha:0.8];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-5)];
        [self addSubview:label];
        
        label.backgroundColor = color;
        label.textColor = [UIColor whiteColor];
        label.shadowColor = [UIColor darkGrayColor];
        label.shadowOffset = CGSizeMake(1, 1);
        label.numberOfLines = 0;
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        label.text = [self labelString];
        
        label.layer.cornerRadius = 10.0;
        
        self.backgroundColor = [UIColor clearColor];
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
