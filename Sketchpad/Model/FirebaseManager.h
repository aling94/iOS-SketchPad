//
//  FirebaseManager.h
//  Sketchpad
//
//  Created by Alvin Ling on 4/29/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase.h>
#import <FirebaseStorage.h>
#import <FirebaseDatabase.h>

NS_ASSUME_NONNULL_BEGIN

@interface FirebaseManager : NSObject
+ (instancetype)shared;
- (void)savePost:(NSString *)user imageURL:(NSString *)imageURL;
- (void)saveImage:(NSString *)user image:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
