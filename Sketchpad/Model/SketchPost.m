//
//  SketchPost.m
//  Sketchpad
//
//  Created by Alvin Ling on 4/29/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import "SketchPost.h"

@implementation SketchPost

- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super init];
    if (self) {
        self.user = info[@"user"];
        self.pid = info[@"pid"];
        self.time = [info[@"time"] doubleValue];
        self.url = info[@"url"];
    }
    return self;
}
@end
