#import "AHLegaleseController.h"

#define SETTING_HAS_ACCEPTED_LEGAL_TERMS @"SETTING_HAS_ACCEPTED_LEGAL_TERMS"

@interface AHLegaleseController ()

@end

@implementation AHLegaleseController

@synthesize delegate = _delegate;

- (id)initWithDelegate:(id<AHLegaleseDelegate>)delegate
{
    self = [super initWithNibName:@"AHLegaleseView" bundle:nil];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (IBAction)onSurePressed:(id)sender {
    [self saveAcceptanceForLegalTerms];
    [_delegate onLegalTermsAccepted];
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(void)saveAcceptanceForLegalTerms {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SETTING_HAS_ACCEPTED_LEGAL_TERMS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)hasAcceptedLegalTerms{
   return [[NSUserDefaults standardUserDefaults] boolForKey:SETTING_HAS_ACCEPTED_LEGAL_TERMS];
}

@end
