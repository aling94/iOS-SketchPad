//
//  SliderView.m
//  Sketchpad
//
//  Created by Alvin Ling on 4/27/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import "SliderView.h"
#import "BrushManager.h"

@interface SliderView()

@property(weak, nonatomic) IBOutlet UILabel *valueText;
@property(weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation SliderView

- (IBAction)sliderChanged:(UISlider *)sender {
    [self changeValue:sender.value];
    
    if (self.delegate)
        [self.delegate sliderDidChange:self sliderValue:sender.value];
}

- (void)changeValue:(float)value {
    [self.slider setValue:value];
    self.valueText.text = (self.slider.maximumValue == 1)? [NSString stringWithFormat:@"%.2f", value] :
        [NSString stringWithFormat:@"%d", (int)value];
}


@end
