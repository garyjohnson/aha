#import "AHImagePickerController.h"
#import "AHCameraOverlayController.h"
#import "AssetsLibrary/AssetsLibrary.h"

@interface AHImagePickerController ()

@end

@implementation AHImagePickerController

UIImagePickerController *imagePickerController;
AHCameraOverlayController *overlayController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidAppear:(BOOL)animated {
    [self showImagePicker];
}

- (void)showImagePicker {
    if (![self isCameraAvailable]) {
        [self showCameraNotAvailableError];
        return;
    }

    [self initializeImagePicker];

    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (BOOL)isCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (void)showCameraNotAvailableError {
    [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Camera not available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)initializeImagePicker {
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.wantsFullScreenLayout = YES;
    imagePickerController.showsCameraControls = NO;
    imagePickerController.navigationBarHidden = YES;

    overlayController = [[AHCameraOverlayController alloc] init];
    overlayController.delegate = self;
    imagePickerController.cameraOverlayView = overlayController.view;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [overlayController setReviewImage:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onShutterPressed {
    [imagePickerController takePicture];
}

- (void)onUsePhotoPressed {
    UIImage *image = overlayController.reviewImage;

    CGRect cropRect= [self getImageCropBounds:image];
    UIImage *croppedImage= [self cropImage:image toBounds:cropRect];

    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[croppedImage CGImage]
                                                     orientation:(ALAssetOrientation)[croppedImage imageOrientation]
                                                 completionBlock:^(NSURL *assetURL, NSError *error){
        if (error != NULL)
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to write" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        else
            [[[UIAlertView alloc] initWithTitle:@"We did it!" message:[assetURL absoluteString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (UIImage *)cropImage:(UIImage *)image toBounds:(CGRect)cropRect {
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return croppedImage;
}

- (CGRect)getImageCropBounds:(UIImage *)image {
    CGRect imagePreviewBounds = [overlayController getImagePreviewBounds];
    CGRect viewportBounds = [overlayController getImageViewportBounds];
    CGFloat x = (viewportBounds.origin.x / imagePreviewBounds.size.width) * image.size.width;
    CGFloat y = (viewportBounds.origin.y  / imagePreviewBounds.size.height) * image.size.height;
    CGFloat width = (viewportBounds.size.width / imagePreviewBounds.size.width) * image.size.width;
    CGFloat height = (viewportBounds.size.height / imagePreviewBounds.size.height) * image.size.height;
    return CGRectMake(y,x,width,height);
}

- (void)onTossPhotoPressed {
    [overlayController clearReviewImage];
}

@end
