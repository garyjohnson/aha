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

- (id)init{
    self = [super initWithNibName:@"AHImagePickerView" bundle:nil];
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
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Camera not available. This app requires a camera to function properly." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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

    NSString *workingDir= [self getWorkingImagesPath];
    NSString *fileName= [self getTemporaryFileName];

    NSError *saveError;
    [self saveImage:croppedImage toPath:workingDir withFileName:fileName error:&saveError];

    if(saveError != nil)
        return;

    NSString *filePath = [workingDir stringByAppendingPathComponent:fileName];
    [uploadManager uploadImageUrl:[NSURL fileURLWithPath:filePath] withEmail:@"gary@gjtt.com" andDeviceId:@"myDeviceId"];
    [[[UIAlertView alloc] initWithTitle:@"We did it!" message:@"The image was successfully uploaded." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (NSString *)getTemporaryFileName {
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
    return [guid stringByAppendingString:@".jpg"];
}

- (NSString *)getWorkingImagesPath {
    NSArray* documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docDir = [documentDirs objectAtIndex:0];
    return [docDir stringByAppendingPathComponent:@"AHAcleveland"];
}

- (void)saveImage:(UIImage *)image toPath:(NSString *)path withFileName:(NSString *)fileName error:(NSError**)error {

    NSString *filePath = [path stringByAppendingPathComponent:fileName];

    if(![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:error];
    }

    if(&error != nil){
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"An error occurred writing image. Please notify the application publisher." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }

    NSData *jpgData = UIImageJPEGRepresentation(image, 1);
    [jpgData writeToFile:filePath options:NSDataWritingFileProtectionComplete error:error];

    if(&error != nil){
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"An error occurred writing image. Please notify the application publisher." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
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
