//
//  UIColor+Extensions.h
//  Sketchpad
//
//  Created by Alvin Ling on 4/26/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Extensions)
- (instancetype)initWithRGB:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

+ (instancetype) lightGreenColor;
+ (instancetype) lightBlueColor;
@end

NS_ASSUME_NONNULL_END
