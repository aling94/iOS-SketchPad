//
//  UIAlertAction+Extensions.h
//  Sketchpad
//
//  Created by Alvin Ling on 4/30/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertAction (Extensions)
+ (instancetype)makeAction:(NSString *)title action:(void (^)(void))action;
@end

NS_ASSUME_NONNULL_END
