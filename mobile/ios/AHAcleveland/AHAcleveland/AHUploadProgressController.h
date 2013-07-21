#import <UIKit/UIKit.h>
#import "UploadManager.h"

#define UPLOADPROGRESSCONTROLLER_RETRY_SELECTED @"UPLOADPROGRESSCONTROLLER_RETRY_SELECTED"

#define UPLOADPROGRESSCONTROLLER_RETRY_DECLINED @"UPLOADPROGRESSCONTROLLER_RETRY_DECLINED"


@interface AHUploadProgressController : UIViewController
{
    NSMutableArray* animationImages;
}

@property (strong, nonatomic) IBOutlet UIButton *buttonRetry;
@property (strong, nonatomic) IBOutlet UIButton *buttonDeclineRetry;

-(void)setForError;
-(void)updateDisplay;
-(void)setForSuccess;

- (IBAction)handleRetry:(id)sender;
- (IBAction)handleRetryDecline:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imageProgressAnimation;
@end
