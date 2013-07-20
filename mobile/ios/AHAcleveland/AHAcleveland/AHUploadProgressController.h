#import <UIKit/UIKit.h>
#import "UploadManager.h"

#define UPLOADPROGRESSCONTROLLER_RETRY_SELECTED @"UPLOADPROGRESSCONTROLLER_RETRY_SELECTED"

#define UPLOADPROGRESSCONTROLLER_RETRY_DECLINED @"UPLOADPROGRESSCONTROLLER_RETRY_DECLINED"


@interface AHUploadProgressController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *buttonRetry;
@property (strong, nonatomic) IBOutlet UIButton *buttonDeclineRetry;

-(void)setForError;
-(void)setForSuccess;

- (IBAction)handleRetry:(id)sender;
- (IBAction)handleRetryDecline:(id)sender;

@end
