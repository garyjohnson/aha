#import "AHImagePickerController.h"
#import "AHCameraOverlayController.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import "UploadManager.h"
#import "AHUploadProgressController.h"

@interface AHImagePickerController ()

@property(retain, readwrite, nonatomic) UIImagePickerController *imagePickerController;
@property(retain, readwrite, nonatomic) AHCameraOverlayController *overlayController;
@property(retain, readwrite, nonatomic) AHUploadProgressController *uploadProgressController;

@end

@implementation AHImagePickerController

@synthesize imagePickerController = _imagePickerController;
@synthesize overlayController = _overlayController;
@synthesize uploadProgressController = _uploadProgressController;

BOOL isFirstTime = YES;

- (id)init {
    self = [super initWithNibName:@"AHImagePickerView" bundle:nil];
    if (self) {
        _uploadProgressController = [[AHUploadProgressController alloc] init];
        [self subscribeToUploadManagerEvents];
        [self subscribeToUploadProgressEvents];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [self initializeImagePicker];

    if (isFirstTime)
        [self showImagePicker];

    isFirstTime = NO;
}

- (void)showImagePicker {
    if (![self isCameraAvailable]) {
        [self showError:@"Camera not available. This app requires a camera to function properly."];
        return;
    }

    [self presentViewController:_imagePickerController animated:NO completion:nil];
}

- (void)initializeImagePicker {
    _imagePickerController = [[UIImagePickerController alloc] init];
    _overlayController = [[AHCameraOverlayController alloc] init];
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePickerController.wantsFullScreenLayout = YES;
    _imagePickerController.showsCameraControls = NO;
    _imagePickerController.navigationBarHidden = YES;
    _imagePickerController.delegate = self;
    _overlayController.delegate = self;
    _imagePickerController.cameraOverlayView = _overlayController.view;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_overlayController setReviewImage:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [_imagePickerController dismissViewControllerAnimated:NO completion:nil];
}

- (void)onShutterPressed {
    [_imagePickerController takePicture];
}

- (void)onUsePhotoPressed {
    UIImage *image = _overlayController.reviewImage;
    CGRect cropRect = [self getImageCropBounds:image];
    UIImage *croppedImage = [self cropImage:image toBounds:cropRect];

    [self saveImageToImageLibraryIfAllowed:croppedImage];
    [self saveAndUploadImage:croppedImage];

}

- (void)saveImage:(UIImage *)image toPath:(NSString *)path withFileName:(NSString *)fileName error:(NSError **)error {

    NSString *filePath = [path stringByAppendingPathComponent:fileName];

    NSError *createDirError;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&createDirError];
    }

    if (createDirError != nil) {
        *error = [NSError errorWithDomain:@"AHAcleveland" code:100 userInfo:nil];
        [self showError:@"An error occurred writing image. Please notify the application publisher."];
        return;
    }

    NSData *jpgData = UIImageJPEGRepresentation(image, 1);
    NSError *writeFileError;
    [jpgData writeToFile:filePath options:NSDataWritingFileProtectionComplete error:&writeFileError];

    if (writeFileError != nil) {
        *error = [NSError errorWithDomain:@"AHAcleveland" code:100 userInfo:nil];
        [self showError:@"An error occurred writing image. Please notify the application publisher."];
        return;
    }
}

- (void)saveImageToImageLibraryIfAllowed:(UIImage *)image {
    [[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[image CGImage]
                                                     orientation:(ALAssetOrientation) [image imageOrientation]
                                                 completionBlock:^(NSURL *assetURL, NSError *error) {
                                                     if (error != nil) {
                                                         [self showError:@"Failed to write to Image Library."];
                                                         return;
                                                     }
                                                 }];
}

- (void)onTossPhotoPressed {
    [_overlayController clearReviewImage];
}

- (void)saveAndUploadImage:(UIImage *)image {
    NSString *workingDir = [self getWorkingImagesPath];
    NSString *fileName = [self getTemporaryFileName];

    image = [self unrotateImage:image];

    NSError *saveError;
    [self saveImage:image toPath:workingDir withFileName:fileName error:&saveError];

    if (saveError != nil)
        return;

    [self showUploadProgress];
    NSString *filePath = [workingDir stringByAppendingPathComponent:fileName];
    [[UploadManager instance] uploadImageUrl:[NSURL fileURLWithPath:filePath] withEmail:@"gary@gjtt.com" andDeviceId:@"myDeviceId"];
}

- (void)showUploadProgress {
    [self dismissCameraAndShowUpload];
}

- (void)dismissCameraAndShowUpload {
    [_imagePickerController dismissViewControllerAnimated:NO completion:^{
        [self presentViewController:_uploadProgressController animated:NO completion:NULL];
    }];
}

- (void)onUploadSuccess {
    [_overlayController clearReviewImage];
    [_uploadProgressController setForSuccess];
    [self dismissUploadAndShowCamera];
}

- (void)dismissUploadAndShowCamera {
    [_uploadProgressController dismissViewControllerAnimated:NO completion:^{
        [self presentViewController:_imagePickerController animated:NO completion:nil];
    }];
}

- (void)onUploadFail {
    [_uploadProgressController setForError];
}

- (void)onUploadCancelled {
    [_overlayController clearReviewImage];
    [_uploadProgressController dismissViewControllerAnimated:NO completion:^{
        [self presentViewController:_imagePickerController animated:NO completion:nil];
    }];
}

- (void)onUploadRetry {
    UIImage *image = _overlayController.reviewImage;
    CGRect cropRect = [self getImageCropBounds:image];
    UIImage *croppedImage = [self cropImage:image toBounds:cropRect];
    [self saveAndUploadImage:croppedImage];
}

- (BOOL)isCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (void)showError:(NSString *)errorMessage {
    [[[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (UIImage *)cropImage:(UIImage *)image toBounds:(CGRect)cropRect {
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return croppedImage;
}

- (CGRect)getImageCropBounds:(UIImage *)image {
    CGRect imagePreviewBounds = [_overlayController getImagePreviewBounds];
    CGRect viewportBounds = [_overlayController getImageViewportBounds];
    CGFloat x = (viewportBounds.origin.x / imagePreviewBounds.size.width) * image.size.width;
    CGFloat y = (viewportBounds.origin.y / imagePreviewBounds.size.height) * image.size.height;
    CGFloat width = (viewportBounds.size.width / imagePreviewBounds.size.width) * image.size.width;
    CGFloat height = (viewportBounds.size.height / imagePreviewBounds.size.height) * image.size.height;
    return CGRectMake(y, x, width, height);
}

- (void)subscribeToUploadManagerEvents {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUploadSuccess) name:UPLOAD_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUploadFail) name:UPLOAD_FAIL object:nil];
}

- (void)subscribeToUploadProgressEvents {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUploadCancelled) name:UPLOADPROGRESSCONTROLLER_RETRY_DECLINED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUploadRetry) name:UPLOADPROGRESSCONTROLLER_RETRY_SELECTED object:nil];
}

- (UIImage *)unrotateImage:(UIImage *)image {
    CGSize size = image.size;
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSString *)getTemporaryFileName {
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
    return [guid stringByAppendingString:@".jpg"];
}

- (NSString *)getWorkingImagesPath {
    NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [documentDirs objectAtIndex:0];
    return [docDir stringByAppendingPathComponent:@"AHAcleveland"];
}

@end
