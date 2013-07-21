#import <UIKit/UIKit.h>
#import "AHSettingsDelegate.h"

@interface AHSettingsViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIButton *notifyMeButton;
@property (nonatomic, strong) IBOutlet UILabel *popoverLabel;
@property (nonatomic, strong) IBOutlet UIImageView *popoverImage;

@property (readwrite) id<AHSettingsDelegate> delegate;

- (id)initWithDelegate:(id<AHSettingsDelegate>)delegate;
-(BOOL)hasShownToUserAtLeastOnce;

@end
