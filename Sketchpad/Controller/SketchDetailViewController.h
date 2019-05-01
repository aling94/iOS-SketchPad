//
//  SketchDetailViewController.h
//  Sketchpad
//
//  Created by Alvin Ling on 5/1/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SketchPost;

NS_ASSUME_NONNULL_BEGIN

@interface SketchDetailViewController : UIViewController
@property (strong, nonatomic, nullable) SketchPost *post;
@property (strong, nonatomic, nullable) UIImage *image;
@end

NS_ASSUME_NONNULL_END
