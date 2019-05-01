//
//  FirebaseManager.m
//  Sketchpad
//
//  Created by Alvin Ling on 4/29/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import "FirebaseManager.h"
#import "SketchPost.h"
#import "LocationManager.h"

@interface FirebaseManager ()

@property (strong, nonatomic) FIRStorageReference *storeRef;
@property (strong, nonatomic) FIRDatabaseReference *dbRef;
@end

@implementation FirebaseManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.storeRef = [[FIRStorage storage] reference];
        self.dbRef = [[FIRDatabase database] reference];
    }
    return self;
}

+ (instancetype)shared {
    static dispatch_once_t pred = 0;
    static id _shared = nil;
    dispatch_once(&pred, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

- (void)savePost:(NSString *)pid user:(NSString *)user imageURL:(NSString *)imageURL completion:(void(^)(NSError * _Nullable))completion {
    NSNumber *time = [NSNumber numberWithDouble:[NSDate.date timeIntervalSince1970]];
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary: @{ @"user": user,
                                                                                  @"pid" : pid,
                                                                                  @"time" : time,
                                                                                  @"url": imageURL,
                                                                                  }];
    LocationManager *locMng = LocationManager.shared;
    
    if (locMng.currentLocation && locMng.locationName) {
        CLLocationCoordinate2D coords = locMng.currentLocation.coordinate;
        [info setObject:[NSNumber numberWithDouble:coords.latitude] forKey:@"lat"];
        [info setObject:[NSNumber numberWithDouble:coords.longitude] forKey:@"lon"];
        [info setObject:locMng.locationName forKey:@"location"];
    }
    
    FIRDatabaseReference *ref = [[self.dbRef child:@"Posts"] child:pid];
    [ref setValue:info withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        completion(error);
    }];
}

- (void)getPosts:(void(^)(NSMutableArray<SketchPost *> *))completion {
    FIRDatabaseReference *ref = [self.dbRef child:@"Posts"];
    [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postList = snapshot.value;
        NSMutableArray<SketchPost *> *posts = NSMutableArray.new;
        if ([postList isKindOfClass:[NSNull class]]) {
            completion(posts);
            return;
        }
        for (NSString *pid in postList) {
            NSDictionary *info = postList[pid];
            SketchPost *post = [SketchPost.alloc initWithInfo:info];
            [posts addObject:post];
        }
        completion(posts);
    }];
}


- (void)saveImage:(NSString *)user image:(UIImage *)image completion:(void(^)(NSError * _Nullable))completion {
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSString *pid = [self.dbRef child:@"Posts"].childByAutoId.key;
    FIRStorageMetadata *meta = [FIRStorageMetadata new];
    [meta setContentType:@"Image/jpeg"];
    FIRStorageReference *ref = [[self.storeRef child:@"Posts"] child:pid];
    
    [ref putData:data metadata:meta completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        if (error) {
            completion(error);
            return;
        }
        [ref downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
            if (error) completion(error);
            else [self savePost:pid user:user imageURL:URL.absoluteString completion:completion];
        }];
    }];
    
}

- (void)deleteImages:(NSArray<NSString *> *)pids {
    for (NSString *pid in pids)
        [self deleteImage:pid completion:^(NSError * _Nullable error) {
            if (error) NSLog(@"%@", error);
        }];
}

- (void)deleteImage:(NSString *)pid completion:(void(^)(NSError * _Nullable))completion {
    FIRDatabaseReference *db = [[self.dbRef child:@"Posts"] child:pid];
    FIRStorageReference *store = [[self.storeRef child:@"Posts"] child:pid];
    [db removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        [store deleteWithCompletion:^(NSError * _Nullable error) {
            completion(error);
        }];
    }];
}

@end
