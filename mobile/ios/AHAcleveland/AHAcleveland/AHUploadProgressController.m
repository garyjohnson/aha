#import "AHUploadProgressController.h"

@interface AHUploadProgressController ()

@end

@implementation AHUploadProgressController

- (id)init {
    self = [super initWithNibName:@"AHUploadProgressView" bundle:nil];
    if (self) {

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleUploadProgress:)
                                                     name:UPLOAD_PROGRESS
                                                   object:nil];
        
        
        NSArray *imageNames = @[@"00.png", @"01.png", @"02.png", @"03.png",
                                @"04.png", @"05.png", @"06.png", @"07.png",
                                @"08.png", @"09.png", @"10.png"];
        
        animationImages = [[NSMutableArray alloc] init];
        for (int i = 0; i < imageNames.count; i++) {
            [animationImages addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
        }
    }
    return self;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _imageProgressAnimation.hidden = false;
    _imageProgressAnimation.animationImages = animationImages;
    _imageProgressAnimation.animationDuration = 5.0;
    
    [_imageProgressAnimation startAnimating];
    
    _imageSuccess.hidden = true;
}

-(void)setForError
{
    _buttonRetry.hidden = false;
    _buttonDeclineRetry.hidden = false;
    
}

-(void)setForSuccess
{
    _buttonRetry.hidden = YES;
    _buttonDeclineRetry.hidden = YES;
    
    _imageProgressAnimation.hidden = true;
    _imageSuccess.hidden = false;
    
    dismissTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(messageToDismiss) userInfo:nil repeats:false];
}

-(void)messageToDismiss
{
    _imageSuccess.hidden = true;
    _imageProgressAnimation.hidden = false;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UPLOADPROGRESSCONTROLLER_SHOULD_DISMISS object:nil userInfo:nil];
}

-(void)handleUploadProgress:(NSNotification*)notification
{
    NSDictionary* userInfo = notification.userInfo;

    int totalExpectedBytes = [userInfo[UPLOAD_TOTALBYTESEXPECTED] intValue];
    int bytesSoFar = [userInfo[UPLOAD_TOTALBYTESSOFAR] intValue];
}

- (IBAction)handleRetry:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UPLOADPROGRESSCONTROLLER_RETRY_SELECTED object:nil userInfo:nil];
}

- (IBAction)handleRetryDecline:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UPLOADPROGRESSCONTROLLER_RETRY_DECLINED object:nil userInfo:nil];
}

@end
