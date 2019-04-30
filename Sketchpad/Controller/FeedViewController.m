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
#import <SVProgressHUD.h>

@interface FeedViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (strong, nonatomic) NSMutableArray<NSIndexPath *> *selectedItems;
@property (strong, nonatomic) NSMutableArray<SketchPost *> *posts;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.posts = [NSMutableArray new];
    self.selectedItems = [NSMutableArray new];
    self.collection.allowsSelection = YES;
    self.collection.allowsMultipleSelection = YES;
    self.navigationItem.title = @"Recent Sketches";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [FirebaseManager.shared getPosts:^(NSMutableArray<SketchPost *> * _Nonnull posts) {
      
        
        self.posts = posts;
        [self.posts sortUsingComparator:^NSComparisonResult(SketchPost *  _Nonnull p1, SketchPost *  _Nonnull p2) {
            return p1.time < p2.time;
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collection reloadData];
        });
    }];
}

- (IBAction)deleteTapped:(id)sender {
    NSMutableIndexSet *indices = [NSMutableIndexSet new];
    for (NSIndexPath *idp in self.selectedItems) {
        [indices addIndex:idp.item];
    }
    [self.posts removeObjectsAtIndexes:indices];
    [self.collection deleteItemsAtIndexPaths:self.selectedItems];
    [self.selectedItems removeAllObjects];
}

- (IBAction)resetTapped:(id)sender {
    for (NSIndexPath *indexPath in self.selectedItems) {
        [self.collection deselectItemAtIndexPath:indexPath animated:YES];
    }
    [self.selectedItems removeAllObjects];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell) return UICollectionViewCell.new;
    SketchPost *post = self.posts[indexPath.row];
    [cell setData:post];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.selectedItems addObject:indexPath];
    NSLog(@"%@", [self selectedItems]);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.selectedItems removeObject:indexPath];
    NSLog(@"%@", [self selectedItems]);
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat size = collectionView.bounds.size.width / 2;
    return CGSizeMake(size, size + 25);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
@end
