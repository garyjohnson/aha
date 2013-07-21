#import <AVFoundation/AVFoundation.h>
#import "AHCameraOverlayController.h"

@interface AHCameraOverlayController ()

@end

@implementation AHCameraOverlayController

@synthesize delegate = _delegate;
@synthesize shutterButton = _shutterButton;
@synthesize usePhotoButton = _usePhotoButton;
@synthesize tossPhotoButton = _tossPhotoButton;
@synthesize reviewImageView = _reviewImageView;
@synthesize reviewImageViewport = _reviewImageViewport;

- (id)initWithDelegate:(id<AHCameraOverlayDelegate>)delegate
{
    self = [super initWithNibName:@"AHCameraOverlayView" bundle:nil];
    if (self) {
        self.delegate = delegate;
        [self enableShutterAfterDelay];
    }
    return self;
}

- (void)enableShutterAfterDelay {
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onCameraReady) userInfo:nil repeats:NO];
}

- (IBAction)onShutterPressed:(id)sender {
    [_delegate onShutterPressed];
}

- (IBAction)onUsePhotoPressed:(id)sender {
    [_delegate onUsePhotoPressed];
}

- (IBAction)onTossPhotoPressed:(id)sender {
    [_delegate onTossPhotoPressed];
}

- (IBAction)onSettingsPressed:(id)sender {
    [_delegate onSettingsPressed];
}

- (void)clearReviewImage {
    [self setReviewImage:nil];
}

- (UIImage *)reviewImage {
    return _reviewImageView.image;
}

- (void)setReviewImage:(UIImage *)reviewImage {
    BOOL isInReviewMode = (reviewImage != nil);
    _reviewImageView.image = reviewImage;
    [self toggleReviewState:isInReviewMode];
}

- (CGRect)getImageViewportBounds {
   return CGRectMake(17,78,282,282);
}

- (CGRect)getImagePreviewBounds {
    return _reviewImageView.bounds;
}

-(void)toggleReviewState:(BOOL)isInReviewMode {
    _shutterButton.hidden = isInReviewMode;
    _usePhotoButton.hidden = !isInReviewMode;
    _tossPhotoButton.hidden = !isInReviewMode;
    _reviewImageView.hidden = !isInReviewMode;
}

-(void)onCameraReady{
    _shutterButton.enabled = YES;
}

@end
