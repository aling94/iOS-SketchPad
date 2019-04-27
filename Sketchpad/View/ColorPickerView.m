//
//  ColorPickerView.m
//  Sketchpad
//
//  Created by Alvin Ling on 4/26/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import "ColorPickerView.h"

@interface ColorPickerView()
@property (weak, nonatomic) IBOutlet UIView *content;


@end


@implementation ColorPickerView



-(void)awakeFromNib {
    [super awakeFromNib];
    CGRect rect = [self.content frame];
    [self setFrame: rect];
}

- (IBAction)pencilTapped:(UIButton *)sender {
    
}

@end
