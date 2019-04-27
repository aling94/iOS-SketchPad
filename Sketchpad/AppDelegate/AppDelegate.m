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
    BrushManager *bm = [BrushManager shared];
    [bm setRed:0];
    [bm setGreen:0];
    [bm setBlue:0];
    [bm setBrush:5];
    [bm setOpacity:1];
    return YES;
}

@end
