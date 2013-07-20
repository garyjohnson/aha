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

- (id)init
{
    self = [super initWithNibName:@"AHCameraOverlayView" bundle:nil];
    if (self) {
    }
    return self;
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
   return CGRectMake(20,58,280,280);
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


@end
