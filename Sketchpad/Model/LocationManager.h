//
//  LocationManager.h
//  Sketchpad
//
//  Created by Alvin Ling on 5/1/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationManager : NSObject

@property (strong, nonatomic, nullable, readonly) CLLocation *currentLocation;
@property (strong, nonatomic, nullable, readonly) NSString *locationName;

+ (instancetype)shared;
- (void)setupCoreLocation;
@end

NS_ASSUME_NONNULL_END
