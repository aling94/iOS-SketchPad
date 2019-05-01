//
//  LocationManager.m
//  Sketchpad
//
//  Created by Alvin Ling on 5/1/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager () <CLLocationManagerDelegate> {
    CLLocationManager *clManager;
}

@property (readwrite) CLLocation *currentLocation;
@property (readwrite) NSString *locationName;

@end

@implementation LocationManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        clManager = [CLLocationManager new];
        clManager.delegate = self;
        clManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return self;
}

+ (instancetype)shared {
    static dispatch_once_t pred = 0;
    static id _shared = nil;
    dispatch_once(&pred, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

- (void)setupCoreLocation {
    [clManager requestWhenInUseAuthorization];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse)
        [manager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *loc = locations.lastObject;
    if (!loc) return;
    CLGeocoder *gc = [CLGeocoder new];
    [gc reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) return;
        self.currentLocation = loc;
        self.locationName = placemarks.lastObject.locality;
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

@end
