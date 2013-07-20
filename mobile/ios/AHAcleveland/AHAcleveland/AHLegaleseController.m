#import "AHLegaleseController.h"

@interface AHLegaleseController ()

@end

@implementation AHLegaleseController

- (id)init
{
    self = [super initWithNibName:@"AHLegaleseView" bundle:nil];
    if (self) {
    }
    return self;
}

- (IBAction)onSurePressed:(id)sender {
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
