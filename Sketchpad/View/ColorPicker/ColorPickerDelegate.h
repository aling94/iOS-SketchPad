//
//  ColorPickerDelegate.h
//  Sketchpad
//
//  Created by Alvin Ling on 4/26/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ColorPickerDelegate <NSObject>
- (void)didSelectColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
