//
//  ImageCell.m
//  Sketchpad
//
//  Created by Alvin Ling on 4/30/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import "ImageCell.h"
#import "SketchPost.h"
#import <SDWebImage/SDWebImage.h>

@interface ImageCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ImageCell

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) [self selectCell];
    else [self unselectCell];
}


- (void)selectCell {
    self.imageView.layer.borderWidth = 2;
    self.imageView.layer.borderColor = UIColor.blackColor.CGColor;
}

- (void)unselectCell {
    self.imageView.layer.borderWidth = 0;
    self.imageView.layer.borderColor = UIColor.clearColor.CGColor;
}

- (void)setData:(SketchPost *)post {
    NSString *url = post.url;
    [self setImage:url];
}

- (void)setImage:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    [self.imageView sd_setImageWithURL:url];
}
@end
