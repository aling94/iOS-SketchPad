//
//  BrushManager.h
//  Sketchpad
//
//  Created by Alvin Ling on 4/26/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BrushManager : NSObject

@property (assign, nonatomic) CGFloat red;
@property (assign, nonatomic) CGFloat green;
@property (assign, nonatomic) CGFloat blue;
@property (assign, nonatomic) CGFloat brush;
@property (assign, nonatomic) CGFloat opacity;
@property (assign, nonatomic) BOOL erase;

+ (instancetype)shared;
- (void)setColor:(UIColor *)color;
- (void)setRedWithInt:(NSInteger)red;
- (void)setGreenWithInt:(NSInteger)green;
- (void)setBlueWithInt:(NSInteger)blue;
- (void)setAlpha:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END
