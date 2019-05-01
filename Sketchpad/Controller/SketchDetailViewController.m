//
//  SketchDetailViewController.m
//  Sketchpad
//
//  Created by Alvin Ling on 5/1/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import "SketchDetailViewController.h"
#import "SketchPost.h"

@interface SketchDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;


@end

@implementation SketchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setupDetails {
    if (!self.post || !self.image) return;
    self.imageView.image = self.image;
    self.creatorLabel.text = [NSString stringWithFormat:@"Posted by: %@", self.post.user];
    self.dateLabel.text =  [NSString stringWithFormat:@"On: %@", [self.post date:@"hh:mm:ss | dd MMM yyyy"]];
    if (self.post.location)
        self.locationLabel.text = [NSString stringWithFormat:@"From: %@", self.post.location];
    
}

@end
