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
#import "SketchDetailViewController.h"

@interface FeedViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (assign, nonatomic) BOOL isEditing;
@property (strong, nonatomic) NSMutableArray<NSIndexPath *> *selectedItems;
@property (strong, nonatomic) NSMutableArray<SketchPost *> *posts;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Recent Sketches";
    self.isEditing = NO;
    self.posts = [NSMutableArray new];
    self.selectedItems = [NSMutableArray new];
    [self setupCollection];
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

- (void)setupCollection {
    self.collection.allowsSelection = self.isEditing;
    self.collection.allowsMultipleSelection = self.isEditing;
}

- (IBAction)deleteTapped:(id)sender {
    if (!self.isEditing) return;
    NSMutableIndexSet *indices = [NSMutableIndexSet new];
    NSMutableArray *pids = [NSMutableArray new];
    for (NSIndexPath *idp in self.selectedItems) {
        [indices addIndex:idp.item];
        [pids addObject:self.posts[idp.item].pid];
    }
    [self.posts removeObjectsAtIndexes:indices];
    [self.collection deleteItemsAtIndexPaths:self.selectedItems];
    [FirebaseManager.shared deleteImages:pids];
    [self.selectedItems removeAllObjects];
}

- (IBAction)editTapped:(UIBarButtonItem *)sender {
    self.isEditing = !self.isEditing;
    [sender setTitle:self.isEditing? @"Done" : @"Edit"];
    [self setCollectionEditMode:self.isEditing];
}

- (void)setCollectionEditMode:(BOOL)editing {
    self.collection.allowsSelection = editing;
    self.collection.allowsMultipleSelection = editing;
    if (!editing) {
        for (NSIndexPath *indexPath in self.selectedItems) {
            [self.collection deselectItemAtIndexPath:indexPath animated:YES];
        }
        [self.selectedItems removeAllObjects];
    }
}

- (void)showPostDetails:(UIButton *)sender {
    SketchDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SketchDetailViewController"];
    vc.post = self.posts[sender.tag];
    ImageCell *cell;
    cell = (ImageCell *)[self.collection cellForItemAtIndexPath:[NSIndexPath indexPathWithIndex:sender.tag]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell) return UICollectionViewCell.new;
    SketchPost *post = self.posts[indexPath.row];
    [cell setData:post];
    cell.infoBtn.tag = indexPath.item;
    [cell.infoBtn addTarget:self action:@selector(showPostDetails:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.selectedItems addObject:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.selectedItems removeObject:indexPath];
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat size = collectionView.bounds.size.width / 2;
    return CGSizeMake(size - 20, size + 25);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 0, 10);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
@end
