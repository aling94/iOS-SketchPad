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
@class SketchPost;

NS_ASSUME_NONNULL_BEGIN

@interface FirebaseManager : NSObject
+ (instancetype)shared;
- (void)saveImage:(NSString *)user image:(UIImage *)image completion:(void(^)(NSError * _Nullable))completion;
- (void)getPosts:(void(^)(NSMutableArray<SketchPost *> *))completion;
- (void)deleteImages:(NSArray<NSString *> *)pids;
@end

NS_ASSUME_NONNULL_END
