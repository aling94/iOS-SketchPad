//
//  SketchDetailViewController.m
//  Sketchpad
//
//  Created by Alvin Ling on 5/1/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import "SketchDetailViewController.h"
#import "SketchPost.h"
#import <SDWebImage.h>

@interface SketchDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;


@end

@implementation SketchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDetails];
}

- (void)setupDetails {
    if (!self.post) return;
    self.creatorLabel.text = [NSString stringWithFormat:@"Posted by: %@", self.post.user];
    self.dateLabel.text =  [NSString stringWithFormat:@"On: %@", [self.post date:@"dd MMM yyyy (hh:mm:ss)"]];
    if (self.post.location)
        self.locationLabel.text = [NSString stringWithFormat:@"From: %@", self.post.location];
    NSURL *url = [NSURL URLWithString:self.post.url];
    [self.imageView sd_setImageWithURL:url];
}

@end
