//
//  SliderView.h
//  Sketchpad
//
//  Created by Alvin Ling on 4/27/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderViewDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface SliderView : UIView
@property (assign, nonatomic) float defaultValue;
@property(weak, nonatomic) id<SliderViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
