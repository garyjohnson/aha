#import <UIKit/UIKit.h>
#import "AHCameraOverlayDelegate.h"

@interface AHCameraOverlayController : UIViewController

@property(atomic, readwrite, retain) id <AHCameraOverlayDelegate> delegate;
@property IBOutlet UIButton *shutterButton;
@property IBOutlet UIButton *usePhotoButton;
@property IBOutlet UIButton *tossPhotoButton;
@property IBOutlet UIImageView *reviewImageView;
@property IBOutlet UIView *reviewImageViewport;

- (IBAction)onShutterPressed:(id)sender;
- (IBAction)onUsePhotoPressed:(id)sender;
- (IBAction)onTossPhotoPressed:(id)sender;

- (void)clearReviewImage;
- (UIImage *)reviewImage;
- (void)setReviewImage:(UIImage *)reviewImage;
- (CGRect)getImagePreviewBounds;
- (CGRect)getImageViewportBounds;

- (id)initWithDelegate:(id<AHCameraOverlayDelegate>)delegate;

@end
