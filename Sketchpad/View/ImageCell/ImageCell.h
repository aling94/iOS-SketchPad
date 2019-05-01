//
//  ImageCell.h
//  Sketchpad
//
//  Created by Alvin Ling on 4/30/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SketchPost;

NS_ASSUME_NONNULL_BEGIN

@interface ImageCell : UICollectionViewCell
- (void)setData:(SketchPost *)post;
@end

NS_ASSUME_NONNULL_END
