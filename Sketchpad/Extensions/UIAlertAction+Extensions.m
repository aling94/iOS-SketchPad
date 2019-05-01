//
//  UIAlertAction+Extensions.m
//  Sketchpad
//
//  Created by Alvin Ling on 4/30/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import "UIAlertAction+Extensions.h"

@implementation UIAlertAction (Extensions)

+ (instancetype)makeAction:(NSString *)title action:(void (^)(void))action {
    UIAlertAction *act = [self actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull _) {
        action();
    }];
    return act;
}

@end
