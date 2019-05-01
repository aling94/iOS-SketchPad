//
//  ImagePicker.h
//  Sketchpad
//
//  Created by Alvin Ling on 4/30/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImagePicker : UIImagePickerController

@property (strong, nonatomic, nullable) void (^selectAction)(UIImage *);

@end

NS_ASSUME_NONNULL_END
