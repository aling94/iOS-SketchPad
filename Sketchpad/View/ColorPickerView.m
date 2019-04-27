//
//  ColorPickerView.m
//  Sketchpad
//
//  Created by Alvin Ling on 4/26/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import "ColorPickerView.h"
#import "UIColor+Extensions.h"
@interface ColorPickerView()
@property (strong, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UIView *content;

- (void)customInit;

@end


@implementation ColorPickerView

- (instancetype)init {
    self = [super init];
    if (self) [self customInit];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) [self customInit];
    return self;
}

+ (NSArray<UIColor *> *)colors {
    static dispatch_once_t pred = 0;
    static NSArray<UIColor *>  *_colors = nil;
    dispatch_once(&pred, ^{
        _colors = [[NSArray<UIColor *> alloc] initWithObjects:
                   UIColor.blackColor,
                   UIColor.grayColor,
                   UIColor.brownColor,
                   UIColor.redColor,
                   UIColor.greenColor,
                   UIColor.blueColor,
                   UIColor.orangeColor,
                   UIColor.yellowColor,
                   UIColor.lightGreenColor,
                   UIColor.lightBlueColor,
                   UIColor.whiteColor, nil];
    });
    return _colors;
}

- (void) customInit {
    [[NSBundle mainBundle] loadNibNamed:@"ColorPickerView" owner:self options:nil];
    [self addSubview:[self view]];
    self.bounds = self.content.frame;
    self.view.frame = self.bounds;
}

- (IBAction)pencilTapped:(UIButton *)sender {
    NSInteger tag = [sender tag];
    UIColor *color = [ColorPickerView colors][tag];
    if([self delegate]) [[self delegate] didSelectColor:color];
}

@end
