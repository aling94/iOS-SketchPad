//
//  ImagePicker.m
//  Sketchpad
//
//  Created by Alvin Ling on 4/30/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import "ImagePicker.h"

@interface ImagePicker () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ImagePicker

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDelegate:self];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.selectAction) self.selectAction(image);
    }];
}

@end
