//
//  BrushManager.m
//  Sketchpad
//
//  Created by Alvin Ling on 4/26/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import "BrushManager.h"

@implementation BrushManager

+ (instancetype)shared {
    static dispatch_once_t pred = 0;
    static id _shared = nil;
    dispatch_once(&pred, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

- (void)setColor:(UIColor *)color {
    CGColorRef cgColor = [color CGColor];
    NSInteger numComponents = CGColorGetNumberOfComponents(cgColor);
    const CGFloat *comps = CGColorGetComponents(cgColor);
    if (numComponents == 4) {
        self.red = comps[0];
        self.green = comps[1];
        self.blue = comps[2];
        NSLog(@"%f %f %f", comps[0], comps[1], comps[2]);
    } else if (numComponents == 2) {
        NSLog(@"%f %f", comps[0], comps[1]);
        self.red = self.green = self.blue = comps[0];
    }
}

- (CGFloat)scaleAndBoundInt:(NSInteger)val {
    return fmin(fmax(0.0, val / 255.0), 1.0);
}

- (void)setRedWithInt:(NSInteger)red {
    self.red = [self scaleAndBoundInt:red];
}

- (void)setGreenWithInt:(NSInteger)green {
    self.green = [self scaleAndBoundInt:green];
}

- (void)setBlueWithInt:(NSInteger)blue {
    self.blue = [self scaleAndBoundInt:blue];
}

- (void)setAlpha:(CGFloat)alpha {
    self.opacity = fmin(fmax(0.0, alpha), 1.0);
}
@end

