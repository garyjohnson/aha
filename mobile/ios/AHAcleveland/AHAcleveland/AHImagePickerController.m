#import "AHImagePickerController.h"
#import "AHCameraOverlayController.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import "UploadManager.h"

@interface AHImagePickerController ()

@end

@implementation AHImagePickerController

UIImagePickerController *imagePickerController;
AHCameraOverlayController *overlayController;
UploadManager *uploadManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        uploadManager = [[UploadManager alloc] init];
    }
    return self;
}

- (NSUInteger)supportedInterfaceOrientations {
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

    CGRect cropRect = [self getImageCropBounds:image];
    UIImage *croppedImage = [self cropImage:image toBounds:cropRect];

    [self saveImageToImageLibraryIfAllowed:croppedImage];

    NSArray* documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docDir = [documentDirs objectAtIndex:0];
    NSString* workingDir = [docDir stringByAppendingPathComponent:@"AHAcleveland"];

    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *fileName = [guid stringByAppendingString:@".jpg"];
    NSString *filePath = [workingDir stringByAppendingPathComponent:fileName];

    NSError *createDirError;
    if(![[NSFileManager defaultManager] fileExistsAtPath:workingDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:workingDir withIntermediateDirectories:NO attributes:nil error:&createDirError];
    }

    if(createDirError != nil){
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to create dir in documents" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }

    NSData *jpgData = UIImageJPEGRepresentation(croppedImage, 1);
    NSError *error;
    [jpgData writeToFile:filePath options:NSDataWritingFileProtectionComplete error:&error];
    if(error != nil){
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to write to documents" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }

    [uploadManager uploadImageUrl:[NSURL fileURLWithPath:filePath] withEmail:@"gary@gjtt.com" andDeviceId:@"nopenopenope"];
    [[[UIAlertView alloc] initWithTitle:@"We did it!" message:filePath delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

}

- (void)saveImageToImageLibraryIfAllowed:(UIImage *)image {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[image CGImage]
                                                     orientation:(ALAssetOrientation) [image imageOrientation]
                                                 completionBlock:^(NSURL *assetURL, NSError *error) {
         if (error != nil) {
             [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to write" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
             return;
         }

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
    CGFloat y = (viewportBounds.origin.y / imagePreviewBounds.size.height) * image.size.height;
    CGFloat width = (viewportBounds.size.width / imagePreviewBounds.size.width) * image.size.width;
    CGFloat height = (viewportBounds.size.height / imagePreviewBounds.size.height) * image.size.height;
    return CGRectMake(y, x, width, height);
}

- (void)onTossPhotoPressed {
    [overlayController clearReviewImage];
}

@end
