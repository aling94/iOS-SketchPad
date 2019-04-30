//
//  ImageCell.m
//  Sketchpad
//
//  Created by Alvin Ling on 4/30/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import "ImageCell.h"
#import "SketchPost.h"

@interface ImageCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ImageCell
- (void)setData:(SketchPost *)post {
    NSString *url = post.url;
    [self setImage:url];
}


- (void)setImage:(NSString *)url {
    
}
@end
