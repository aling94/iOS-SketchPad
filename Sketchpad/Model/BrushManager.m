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

- (void)setAlpha:(CGFloat)alpha {
    self.opacity = (0 <= alpha && alpha <= 1)? alpha : 1;
}
@end

