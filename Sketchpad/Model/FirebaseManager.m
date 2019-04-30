//
//  FirebaseManager.m
//  Sketchpad
//
//  Created by Alvin Ling on 4/29/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import "FirebaseManager.h"
#import "SketchPost.h"

@interface FirebaseManager()

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

- (void)addPostToUser:(NSString *)user imageURL:(NSString *)url {
    FIRDatabaseReference *ref = [[self.dbRef child:@"Users"] child:user];
    
   
}

- (void)savePost:(NSString *)pid user:(NSString *)user imageURL:(NSString *)imageURL {
    NSNumber *time = [NSNumber.alloc initWithDouble:[NSDate.date timeIntervalSince1970]];
    NSDictionary *info;
    info = @{ @"user": user,
              @"pid" : pid,
              @"time" : time,
              @"url": imageURL
              };
    
    FIRDatabaseReference *ref = [[self.dbRef child:@"Posts"] child:pid];
    [ref setValue:info withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
    }];
}

- (void)getPosts:(void(^)(NSArray<SketchPost *> *))completion {
    FIRDatabaseReference *ref = [self.dbRef child:@"Posts"];
    [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postList = snapshot.value;
        
        NSMutableArray<SketchPost *> *posts = NSMutableArray.new;
        for (NSString *pid in postList) {
            NSDictionary *info = postList[pid];
            SketchPost *post = [SketchPost.alloc initWithInfo:info];
            [posts addObject:post];
        }
        completion(posts);
    }];
}


- (void)saveImage:(NSString *)user image:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSString *pid = [self.dbRef child:@"Posts"].childByAutoId.key;
    NSString *filename = [NSString stringWithFormat:@"%f_@id:%@_@user:%@", [NSDate.date timeIntervalSince1970], pid, user];
    FIRStorageMetadata *meta = [FIRStorageMetadata new];
    [meta setContentType:@"Image/jpeg"];
    FIRStorageReference *ref = [[self.storeRef child:@"Posts"] child:filename];
    
    [ref putData:data metadata:meta completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        [ref downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
            [self savePost:pid user:user imageURL:URL.absoluteString];
        }];
    }];
    
}

@end
