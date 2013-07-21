#import "AHImagePickerController.h"
#import "AHCameraOverlayController.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import "UploadManager.h"
#import "AHUploadProgressController.h"
#import "AHLegaleseController.h"
#import "AHSettingsViewController.h"
#import "UserSession.h"
#import "AppDelegate.h"

@interface AHImagePickerController ()

@property(retain, readwrite) UIImagePickerController *imagePickerController;
@property(retain, readwrite) AHCameraOverlayController *overlayController;
@property(retain, readwrite) AHUploadProgressController *uploadProgressController;
@property(retain, readwrite) AHLegaleseController *legaleseController;
@property(retain, readwrite) AHSettingsViewController *settingsController;
@property(retain, readwrite) NSURL *currentUploadingImageUrl;

@end

@implementation AHImagePickerController

@synthesize imagePickerController = _imagePickerController;
@synthesize overlayController = _overlayController;
@synthesize uploadProgressController = _uploadProgressController;
@synthesize legaleseController = _legaleseController;
@synthesize settingsController = _settingsController;
@synthesize currentUploadingImageUrl = _currentUploadingImageUrl;

BOOL isFirstTimeLoading = YES;
BOOL isShowingSettingsBeforeUpload = NO;

- (id)init {
    self = [super initWithNibName:@"AHImagePickerView" bundle:nil];
    if (self) {
        _legaleseController = [[AHLegaleseController alloc] initWithDelegate:self];
        _uploadProgressController = [[AHUploadProgressController alloc] init];
        _settingsController = [[AHSettingsViewController alloc] initWithDelegate:self];
        [self subscribeToUploadManagerEvents];
        [self subscribeToUploadProgressEvents];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [self initializeImagePicker];

    if (isFirstTimeLoading)
        [self navigateOnFirstTimeLoading];

    isFirstTimeLoading = NO;
}

- (void)navigateOnFirstTimeLoading {
    if (![_legaleseController hasAcceptedLegalTerms])
        [self showLegalTerms];
    else
        [self showImagePicker];
}

- (void)showLegalTerms {
    [self presentViewController:_legaleseController animated:NO completion:nil];
}

- (void)onLegalTermsAccepted {
    [_legaleseController dismissViewControllerAnimated:NO completion:^{
        [self showImagePicker];
    }];
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
    _overlayController = [[AHCameraOverlayController alloc] initWithDelegate:self];
    if ([self isCameraAvailable]) {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePickerController.wantsFullScreenLayout = YES;
        _imagePickerController.showsCameraControls = NO;
        _imagePickerController.navigationBarHidden = YES;
        _imagePickerController.cameraOverlayView = _overlayController.view;
    }
    _imagePickerController.delegate = self;
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
    if ([_settingsController hasShownToUserAtLeastOnce]) {
        [self saveAndUploadCroppedImage];
    }
    else {
        isShowingSettingsBeforeUpload = YES;
        [self dismissCameraAndShowSettings];
    }
}

- (void)saveAndUploadCroppedImage {
    UIImage *image = _overlayController.reviewImage;
    CGRect cropRect = [self getImageCropBounds:image];
    UIImage *croppedImage = [self cropImage:image toBounds:cropRect];

    [self saveImageToImageLibraryIfAllowed:croppedImage];
    [self uploadImage:croppedImage];
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
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:[image CGImage]
                              orientation:(ALAssetOrientation) [image imageOrientation]
                          completionBlock:nil];
}

- (void)onTossPhotoPressed {
    [_overlayController clearReviewImage];
}

- (void)uploadImage:(UIImage *)image {
    NSString *workingDir = [self getWorkingImagesPath];
    NSString *fileName = [self getTemporaryFileName];

    image = [self unrotateImage:image];

    NSError *saveError;
    [self saveImage:image toPath:workingDir withFileName:fileName error:&saveError];

    if (saveError != nil)
        return;

    [self showUploadProgress];
    NSString *filePath = [workingDir stringByAppendingPathComponent:fileName];
    NSString *installationId = [((AppDelegate *) [[UIApplication sharedApplication] delegate]) installationId];
    self.currentUploadingImageUrl = [NSURL fileURLWithPath:filePath];
    [[UploadManager instance] uploadImageUrl:_currentUploadingImageUrl withEmail:[UserSession getEmail] andDeviceId:installationId];
}

- (void)showUploadProgress {
    [self dismissCameraAndShowUpload];
}

- (void)dismissCameraAndShowUpload {
    [_imagePickerController dismissViewControllerAnimated:NO completion:^{
        [self presentViewController:_uploadProgressController animated:NO completion:NULL];
    }];
}

- (void)dismissCameraAndShowSettings {
    [_imagePickerController dismissViewControllerAnimated:NO completion:^{
        [self presentViewController:_settingsController animated:NO completion:NULL];
    }];
}

- (void)dismissSettingsAndStartUpload {
    [_settingsController dismissViewControllerAnimated:NO completion:^{
        [self presentViewController:_imagePickerController animated:NO completion:^{
            [self saveAndUploadCroppedImage];
        }];
    }];
}

- (void)dismissSettingsAndShowCamera {
    [_settingsController dismissViewControllerAnimated:NO completion:^{
        [self presentViewController:_imagePickerController animated:NO completion:NULL];
    }];
}

- (void)onUploadSuccess {
    [self deleteTempImageIfExists];
    [_overlayController clearReviewImage];
    [_uploadProgressController setForSuccess];
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
    [self deleteTempImageIfExists];
    [_overlayController clearReviewImage];
    [_uploadProgressController dismissViewControllerAnimated:NO completion:^{
        [self presentViewController:_imagePickerController animated:NO completion:nil];
    }];
}

- (void)deleteTempImageIfExists {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (_currentUploadingImageUrl != nil &&
            [fileManager isDeletableFileAtPath:[_currentUploadingImageUrl relativePath]])
        [fileManager removeItemAtPath:[_currentUploadingImageUrl relativePath] error:nil];
}

- (void)onUploadRetry {
    UIImage *image = _overlayController.reviewImage;
    CGRect cropRect = [self getImageCropBounds:image];
    UIImage *croppedImage = [self cropImage:image toBounds:cropRect];
    [self uploadImage:croppedImage];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUploadDismiss) name:UPLOADPROGRESSCONTROLLER_SHOULD_DISMISS object:nil];
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

- (void)onSettingsPressed {
    [self dismissCameraAndShowSettings];
}

- (void)onSettingsSaved {
    if (isShowingSettingsBeforeUpload) {
        isShowingSettingsBeforeUpload = NO;
        [self dismissSettingsAndStartUpload];
    }
    else {
        [self dismissSettingsAndShowCamera];
    }
}

- (void)onUploadDismiss {
    [self dismissUploadAndShowCamera];
}

@end
