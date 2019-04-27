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
- (instancetype)initWithRGB:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
- (instancetype)initWithRGB:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)a;
+ (instancetype)darkGreenColor;
+ (instancetype)lightGreenColor;
+ (instancetype)lightBlueColor;
@end

NS_ASSUME_NONNULL_END
