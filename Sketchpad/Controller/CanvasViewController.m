//
//  CanvasViewController.m
//  Sketchpad
//
//  Created by Alvin Ling on 4/26/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

#import "CanvasViewController.h"
#import "ColorPickerView.h"
#import "ColorPickerDelegate.h"
#import "UIColor+Extensions.h"
#import "BrushManager.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MessageUI.h>
#import "FirebaseManager.h"
#import <SVProgressHUD.h>
#import <AVFoundation/AVFoundation.h>
#import "ImagePicker.h"

@interface CanvasViewController () <UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, ColorPickerDelegate> {
    CGPoint lastPoint;
    CGSize canvasSize;
    BrushManager *bm;
    BOOL swiped;
}

@property (weak, nonatomic) IBOutlet ColorPickerView *colorPicker;
@property (weak, nonatomic) IBOutlet UIImageView *mainCanvas;
@property (weak, nonatomic) IBOutlet UIImageView *tempCanvas;

@end

@implementation CanvasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.colorPicker setDelegate:self];
    canvasSize = self.mainCanvas.frame.size;
    bm = [BrushManager shared];
    bm.opacity = 1;
}

- (IBAction)resetTapped:(id)sender {
    [self.mainCanvas setImage:nil];
}

- (IBAction)uploadImgTapped:(id)sender {
    [self promptUploadImage];
}

- (IBAction)menuTapped:(id)sender {
    if (!self.mainCanvas.image) return;
    UIImage *saveImage = [self getDrawing];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Save options" message: @"What would you like to do?" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *toPhotos = [UIAlertAction makeAction:@"Save to Photo Library" action:^{
        UIImageWriteToSavedPhotosAlbum(saveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
    
    UIAlertAction *toTwitter = [UIAlertAction makeAction:@"Post to Twitter"  action:^{
        [self twitterUpload:saveImage];
    }];
    
    UIAlertAction *toMail = [UIAlertAction makeAction:@"Send as Email" action:^{
        [self sendMail:saveImage];
    }];
    
    UIAlertAction *toCloud = [UIAlertAction makeAction:@"Upload to Sketch-Cloud" action:^{
        [self saveToCloud:saveImage];
    }];
    
    [alert addAction:toPhotos];
    [alert addAction:toTwitter];
    [alert addAction:toMail];
    [alert addAction:toCloud];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * action) {}]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)promptUploadImage {
    ImagePicker *picker = ImagePicker.new;
    __weak CanvasViewController *weakself = self;
    picker.selectAction = ^(UIImage * _Nonnull image) {
        [weakself.tempCanvas setImage:image];
        [weakself.mainCanvas setImage:nil];
    };
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *title = (error)? @"Error" : @"Success";
    NSString *msg = (error)? @"Image could not be saved. Please try again." : @"Image was successfully saved.";
    [self showAlert:title message:msg];
}

- (void)twitterUpload:(UIImage *)image {
    SLComposeViewController *composer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [composer setInitialText:@"Sketch"];
    [composer addImage:image];
    [composer setCompletionHandler:^(SLComposeViewControllerResult result) {
        switch (result) {
                case SLComposeViewControllerResultCancelled:
                [self showAlert:@"Error" message:@"Twitter app and a logged in account required to post to Twitter."];
                break;
                case SLComposeViewControllerResultDone:
                [self showAlert:@"Success" message:@"Post successful."];
                break;
            default:
                break;
        }
    }];
    [self presentViewController:composer animated:YES completion:nil];
}

- (void)sendMail:(UIImage *)image {
    if (![MFMailComposeViewController canSendMail]) {
        [self showAlert:@"Error" message:@"This device cannot send mail!"];
        return;
    }
    
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
    [mailVC setMailComposeDelegate:self];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    [mailVC addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"sketch.jpeg"];
    [mailVC setSubject:@"iOS-Sketchpad drawing"];
    [self presentViewController:mailVC animated:YES completion:nil];
}

- (void)saveToCloud:(UIImage *)image {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Your name please." message: @"Please give your desired username to save this under or leave blank to be Anonymous." preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"Name"];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * action) {}]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSString *name = alert.textFields.firstObject.text;
        name = (!name || [name length] == 0 )? @"Anonynmous" : name;
        [SVProgressHUD show];
        [FirebaseManager.shared saveImage:name image:image completion:^(NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                if (error) [self showAlert:@"Error" message:[error localizedDescription]];
                else [self showAlert:@"Success" message:@"Image successfully saved"];
            });
        }];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma MARK: - Drawing

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    swiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.tempCanvas];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    swiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.tempCanvas];
    
    [self prepareToDraw:1.0];
    CGBlendMode mode = bm.erase? kCGBlendModeClear : kCGBlendModeNormal;
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), mode);
    [self drawLine:lastPoint end:currentPoint];
    [self.tempCanvas setAlpha: bm.opacity];
    [self endDrawing];
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!swiped) {
        [self prepareToDraw:bm.opacity];
        [self drawLine:lastPoint end:lastPoint];
        CGContextFlush(UIGraphicsGetCurrentContext());
        [self endDrawing];
    }
    [self transferToMainCanvas];
    
}

#pragma MARK: - Drawing helpers

- (void)prepareToDraw:(CGFloat)alpha {
    CGRect scaled = AVMakeRectWithAspectRatioInsideRect(self.tempCanvas.image.size, self.tempCanvas.bounds);
    UIGraphicsBeginImageContext(canvasSize);
    [self.tempCanvas.image drawInRect:scaled];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), bm.brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), bm.red, bm.green, bm.blue, alpha);
}

- (void)drawLine:(CGPoint)start end:(CGPoint)end {
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), start.x, start.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), end.x, end.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
}

- (void)endDrawing {
    self.tempCanvas.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)transferToMainCanvas {
    
    UIGraphicsBeginImageContext(canvasSize);
    [self.mainCanvas.image drawInRect:CGRectMake(0, 0, canvasSize.width, canvasSize.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempCanvas.image drawInRect:CGRectMake(0, 0, canvasSize.width, canvasSize.height) blendMode:kCGBlendModeNormal alpha:bm.opacity];
    
    [self.mainCanvas setContentMode:UIViewContentModeScaleAspectFit];
    self.mainCanvas.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempCanvas.image = nil;
    UIGraphicsEndImageContext();
}

- (UIImage *)getDrawing {
    UIGraphicsBeginImageContextWithOptions(canvasSize, NO, 0.0);
    [self.mainCanvas.image drawInRect:CGRectMake(0, 0, canvasSize.width, canvasSize.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma MARK: - ColorPickerDelegate

- (void)didSelectColor:(nonnull UIColor *)color {
    [bm setColor:color];
}

#pragma MARK: - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            [self showAlert:@"Success" message:@"Message sent."];
            break;
        case MFMailComposeResultFailed:
            [self showAlert:@"Error" message:@"An error occurred while composing the mail."];
            break;
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

@end
