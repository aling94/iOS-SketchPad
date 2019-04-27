//
//  CanvasViewController.m
//  Sketchpad
//
//  Created by Alvin Ling on 4/26/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import "CanvasViewController.h"
#import "ColorPickerView.h"
#import "ColorPickerDelegate.h"
#import "UIColor+Extensions.h"

@interface CanvasViewController () <ColorPickerDelegate> {
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
}


@property (weak, nonatomic) IBOutlet ColorPickerView *colorPicker;

- (void)setColor:(UIColor *)color;


@end

@implementation CanvasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.colorPicker setDelegate:self];
    red = 0;
    green = 0;
    blue = 0;
    brush = 5;
    opacity = 1;
}

- (void)setColor:(UIColor *)color {
    CGColorRef cgColor = [color CGColor];
    NSInteger numComponents = CGColorGetNumberOfComponents(cgColor);
    const CGFloat *comps = CGColorGetComponents(cgColor);
    if (numComponents == 4) {
        red = comps[0];
        green = comps[1];
        blue = comps[2];
        NSLog(@"%f %f %f", comps[0], comps[1], comps[2]);
    } else {
        NSLog(@"%f %f", comps[0], comps[1]);
        red = green = blue = comps[0];
    }
}

- (void)didSelectColor:(nonnull UIColor *)color {
    [self setColor:color];
}


@end
