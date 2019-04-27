//
//  SliderViewDelegate.h
//  Sketchpad
//
//  Created by Alvin Ling on 4/27/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SliderViewDelegate <NSObject>
- (void)sliderDidChange:(float)value;
@end

NS_ASSUME_NONNULL_END
