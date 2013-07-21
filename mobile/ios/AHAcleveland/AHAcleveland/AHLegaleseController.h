#import <UIKit/UIKit.h>
#import "AHLegaleseDelegate.h"

@interface AHLegaleseController : UIViewController

@property (retain, readwrite, atomic) id<AHLegaleseDelegate> delegate;

-(IBAction)onSurePressed:(id)sender;

-(id)initWithDelegate:(id<AHLegaleseDelegate>)delegate;
-(BOOL)hasAcceptedLegalTerms;

@end
