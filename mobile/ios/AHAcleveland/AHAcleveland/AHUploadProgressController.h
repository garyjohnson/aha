#import <UIKit/UIKit.h>

@interface AHUploadProgressController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *buttonRetry;

-(void)setForError;
-(void)updateDisplay;


@end
