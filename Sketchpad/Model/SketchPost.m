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
        self.location = info[@"location"];
        self.coords = CLLocationCoordinate2DMake(0, 0);
        if (self.location) {
            double lat = [info[@"lat"] doubleValue];
            double lon = [info[@"lon"] doubleValue];
            self.coords = CLLocationCoordinate2DMake(lat, lon);
        }
        NSLog(@"%@", [self date:@"hh:mm:ss | dd MMM yyyy"]);
    }
    return self;
}

- (NSString *)date:(NSString *)format {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = format;
    NSDate *date = [NSDate.new initWithTimeIntervalSince1970: self.time];
    return [formatter stringFromDate:date];
}
@end
