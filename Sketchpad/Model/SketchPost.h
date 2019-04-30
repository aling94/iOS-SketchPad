//
//  SketchPost.h
//  Sketchpad
//
//  Created by Alvin Ling on 4/29/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SketchPost : NSObject
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSString *pid;
@property (strong, nonatomic) NSString *url;
@property (assign, nonatomic) NSTimeInterval time;

- (instancetype)initWithInfo:(NSDictionary *)info;
@end

NS_ASSUME_NONNULL_END
