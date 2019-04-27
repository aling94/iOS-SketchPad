//
//  SettingsViewController.m
//  Sketchpad
//
//  Created by Alvin Ling on 4/27/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import "SettingsViewController.h"
#import "SliderView.h"
#import "SliderViewDelegate.h"
#import "BrushManager.h"
@interface SettingsViewController () <SliderViewDelegate>{
    BrushManager *bm;
    CGSize previewSize;
}
@property (weak, nonatomic) IBOutlet UIImageView *preview;
@property (weak, nonatomic) IBOutlet SliderView *brushSlider;
@property (weak, nonatomic) IBOutlet SliderView *alphaSlider;
@property (weak, nonatomic) IBOutlet SliderView *redSlider;
@property (weak, nonatomic) IBOutlet SliderView *greenSlider;
@property (weak, nonatomic) IBOutlet SliderView *blueSlider;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    bm = [BrushManager shared];
    previewSize = self.preview.frame.size;
    [self setupSliders];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.brushSlider changeValue:bm.brush];
    [self.alphaSlider changeValue:bm.opacity];
    [self.redSlider changeValue:bm.red * 255];
    [self.greenSlider changeValue:bm.green * 255];
    [self.blueSlider changeValue:bm.blue * 255];
    [self showBrushPreview];
}


- (void)setupSliders {
    [self.brushSlider setDelegate:self];
    [self.alphaSlider setDelegate:self];
    [self.redSlider setDelegate:self];
    [self.greenSlider setDelegate:self];
    [self.blueSlider setDelegate:self];
}


- (void)sliderDidChange:(SliderView *)slider sliderValue:(float)value {
    switch (slider.tag) {
        case 0:
            [bm setBrush:value];
            break;
        case 1:
            [bm setOpacity:value];
            break;
        case 2:
            [bm setRedWithInt:value];
            break;
        case 3:
            [bm setGreenWithInt:value];
            break;
        case 4:
            [bm setBlueWithInt:value];
            break;
        default:
            break;
    }
    [self showBrushPreview];
}

- (void)showBrushPreview {
    CGFloat x = previewSize.width / 2;
    CGFloat y = previewSize.height / 2;
    
    UIGraphicsBeginImageContext(previewSize);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), bm.brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), bm.red, bm.green, bm.green, bm.opacity);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), x, y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), x, y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.preview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}
@end
