//
//  UIColor+Extensions.m
//  Sketchpad
//
//  Created by Alvin Ling on 4/26/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import "UIColor+Extensions.h"

@implementation UIColor (Extensions)
- (instancetype)initWithRGB:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    
    CGFloat r = red / 255.0;
    CGFloat g = green / 255.0;
    CGFloat b = blue / 255.0;
    return [self initWithRGB:r green:g blue:b];
}

+ (instancetype)lightGreenColor {
    return [self.alloc initWithRGB:102 green:255 blue:0];
}

+ (instancetype)lightBlueColor {
    return [self.alloc initWithRGB:51 green:204 blue:255];
}
@end
