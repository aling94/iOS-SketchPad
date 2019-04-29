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

- (IBAction)saveTapped:(id)sender {
    if (!self.mainCanvas.image) return;
    UIImage *saveImage = [self getDrawing];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Save to where?" message: @"Where would you like to save this?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *toPhotos = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImageWriteToSavedPhotosAlbum(saveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
    UIAlertAction *toTwitter = [UIAlertAction actionWithTitle:@"Twitter" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self twitterUpload:saveImage];
    }];
    
    UIAlertAction *toMail = [UIAlertAction actionWithTitle:@"Email" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self sendMail:saveImage];
    }];
    
    [alert addAction:toPhotos];
    [alert addAction:toTwitter];
    [alert addAction:toMail];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * action) {}]];
    [self presentViewController:alert animated:YES completion:nil];
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
                NSLog(@"Post Canceled");
                break;
                case SLComposeViewControllerResultDone:
                NSLog(@"Post Sucessful");
                break;
            default:
                break;
        }
    }];
    [self presentViewController:composer animated:YES completion:nil];
}

- (void)sendMail:(UIImage *)image {
    if (![MFMailComposeViewController canSendMail]) {
        [self showAlert:@"Error!" message:@"This device cannot send mail!"];
        return;
    }
    
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
    [mailVC setMailComposeDelegate:self];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    [mailVC addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"sketch.jpeg"];
    [mailVC setSubject:@"iOS-Sketchpad drawing"];
    [self presentViewController:mailVC animated:YES completion:nil];
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
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
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
    UIGraphicsBeginImageContext(canvasSize);
    [self.tempCanvas.image drawInRect:CGRectMake(0, 0, canvasSize.width, canvasSize.height)];
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
