//
//  FeedViewController.m
//  Sketchpad
//
//  Created by Alvin Ling on 4/30/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import "FeedViewController.h"
#import "FirebaseManager.h"
#import "SketchPost.h"
#import "ImageCell.h"
@interface FeedViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (strong, nonatomic) NSArray<SketchPost *> * posts;

@end

@implementation FeedViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.posts = [NSArray new];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [FirebaseManager.shared getPosts:^(NSArray<SketchPost *> * _Nonnull posts) {
        self.posts = posts;
        for (SketchPost *p in posts) {
            NSLog(@"%@", p.url);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collection reloadData];
        });
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell) return UICollectionViewCell.new;
    [cell setImage:@""];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(200, 200);
}
@end
