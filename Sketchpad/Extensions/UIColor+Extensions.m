//
//  UIColor+Extensions.m
//  Sketchpad
//
//  Created by Alvin Ling on 4/26/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import "UIColor+Extensions.h"


@implementation UIColor (Extensions)
- (instancetype)initWithRGB:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue {
    CGFloat r = red / 255.0;
    CGFloat g = green / 255.0;
    CGFloat b = blue / 255.0;
    return self = [self initWithRed:r green:g blue:b alpha:1];
}

- (instancetype)initWithRGB:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)a {
    CGFloat r = red / 255.0;
    CGFloat g = green / 255.0;
    CGFloat b = blue / 255.0;
    return self = [self initWithRed:r green:g blue:b alpha:a];
}

+ (instancetype)darkGreenColor {
    return [self.alloc initWithRGB:82 green:119 blue:32];
}

+ (instancetype)lightGreenColor {
    return [self.alloc initWithRGB:102 green:255 blue:0];
}

+ (instancetype)lightBlueColor {
    return [self.alloc initWithRGB:51 green:204 blue:255];
}
@end
