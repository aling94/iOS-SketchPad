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

- (void)awakeFromNib {
    [super awakeFromNib];
    [self changeValueText:self.defaultValue];
}

- (IBAction)sliderChanged:(UISlider *)sender {
    [self changeValueText:sender.value];
    
    if (self.delegate)
        [self.delegate sliderDidChange:sender.value];
}

- (void)changeValueText:(float)value {
    self.valueText.text = (self.slider.maximumValue == 1)?
    [NSString stringWithFormat:@"%.2f", value] :
    [NSString stringWithFormat:@"%d", (int)value];
}


@end
