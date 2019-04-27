//
//  AppDelegate.m
//  Sketchpad
//
//  Created by Alvin Ling on 4/26/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import "AppDelegate.h"
#import "BrushManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [BrushManager.shared setColor:UIColor.blackColor];
    [BrushManager.shared setAlpha:1];
    [BrushManager.shared setBrush:5];
    return YES;
}

@end
