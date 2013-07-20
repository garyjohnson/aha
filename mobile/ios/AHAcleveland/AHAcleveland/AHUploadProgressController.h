#import <UIKit/UIKit.h>

#define UPLOADPROGRESSCONTROLLER_RETRY_SELECTED @"UPLOADPROGRESSCONTROLLER_RETRY_SELECTED"


@interface AHUploadProgressController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *buttonRetry;

-(void)setForError;
-(void)updateDisplay;

- (IBAction)handleRetry:(id)sender;

@end
