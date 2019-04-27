//
//  ColorPickerView.h
//  Sketchpad
//
//  Created by Alvin Ling on 4/26/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface ColorPickerView : UIView

@property (weak, nonatomic) id<ColorPickerDelegate> delegate;

+ (NSArray<UIColor *> *) colors;

@end

NS_ASSUME_NONNULL_END
