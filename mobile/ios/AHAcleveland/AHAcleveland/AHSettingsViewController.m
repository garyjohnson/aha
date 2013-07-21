#import "AHSettingsViewController.h"
#import "UserSession.h"

#define SETTING_HAS_SHOWN_SETTINGS_TO_USER = @"SETTING_HAS_SHOWN_SETTINGS_TO_USER"

@interface AHSettingsViewController ()
{
    int originalOffset;
    BOOL popoverShown;
}

@end

@implementation AHSettingsViewController

@synthesize delegate = _delegate;

- (id)initWithDelegate:(id<AHSettingsDelegate>)delegate
{
    self = [super initWithNibName:@"AHSettingsViewController" bundle:nil];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    self.emailTextField.borderStyle = UITextBorderStyleNone;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    originalOffset = self.cancelButton.frame.origin.y + self.cancelButton.frame.size.height;
    [self initializeEmail];
}

#pragma mark -
#pragma mark

- (void) keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    [self animateButtonsWithOffset:(keyboardFrame.size.height - (self.view.frame.size.height - originalOffset - 2)) * -1 withDuration:animationDuration withCurve:animationCurve];
}

- (void) keyboardWillHide:(NSNotification*)notification
{
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    [self animateButtonsWithOffset:keyboardFrame.size.height - (self.view.frame.size.height - originalOffset - 2) withDuration:animationDuration withCurve:animationCurve];
}

#pragma mark -
#pragma mark

- (void) onSingleTap:(UITapGestureRecognizer*)tap
{
    if (popoverShown)
    {
        [self setPopoverShown:NO];
    }
}

#pragma mark -
#pragma mark

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField)
    {
        [self submitTouchUpInside];
        [self.emailTextField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length > 0)
    {
        [self setCheckboxChecked:YES];
    }
    else
    {
        if (range.location == 0)
        {
            [self setCheckboxChecked:NO];
        }
    }
    
    return YES;
}

#pragma mark -
#pragma mark

- (void) alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        [self.emailTextField becomeFirstResponder];
    }
}

#pragma mark -
#pragma mark

- (IBAction) submitTouchUpInside
{
    NSString *email = self.emailTextField.text;
    
    if (email.length > 0)
    {
        [self setCheckboxChecked:YES];
        
        if ([self isValidEmail:email])
        {
            if ([UserSession setEmail:self.emailTextField.text])
            {
                [self onDismiss];
            }
            else
            {
                [self showErrorWithMessage:@"Oops, something went wrong."];
            }
        }
        else
        {
            [self showErrorWithMessage:@"The e-mail address you entered has an invalid format.  Please re-enter."];
        }
    }
    else
    {
        if (self.notifyMeButton.selected)
        {
            [self showErrorWithMessage:@"Can't notify you with an empty e-mail address, silly."];
        }
        else
        {
            [self setCheckboxChecked:NO];
            [self onDismiss];
        }
    }
}

- (IBAction) clearTouchUpInside
{
    self.emailTextField.text = nil;
    [UserSession setEmail:@""];
    [self.emailTextField resignFirstResponder];
    [self setCheckboxChecked:NO];
}

- (IBAction) whatButtonTouchUpInside
{
    [self setPopoverShown:!popoverShown];
}

- (IBAction) notifyMeTouchUpInside
{
    if (!self.notifyMeButton.selected)
    {
        [self setCheckboxChecked:YES];
        
        if (self.emailTextField.text.length == 0)
        {
            [self.emailTextField becomeFirstResponder];
        }
    }
    else
    {
        [self setCheckboxChecked:NO];
        self.emailTextField.text = @"";
        [UserSession setEmail:@""];
        [self.emailTextField resignFirstResponder];
    }
}

- (void) showErrorWithMessage:(NSString*)message
{
    UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    error.tag = 1;
    [error show];
    
    [self.emailTextField becomeFirstResponder];
}

- (void) animateButtonsWithOffset:(int)offset withDuration:(NSTimeInterval)duration withCurve:(UIViewAnimationCurve)curve
{
    [UIView animateWithDuration:duration delay:0 options:curve animations:^{
        self.submitButton.frame = CGRectMake(self.submitButton.frame.origin.x, self.submitButton.frame.origin.y + offset, self.submitButton.frame.size.width, self.submitButton.frame.size.height);
        
        self.cancelButton.frame = CGRectMake(self.cancelButton.frame.origin.x, self.cancelButton.frame.origin.y + offset, self.cancelButton.frame.size.width, self.cancelButton.frame.size.height);
    } completion:^(BOOL finished) {}];
}

- (void) initializeEmail
{
    self.emailTextField.text = [UserSession getEmail];
    
    if (self.emailTextField.text.length > 0)
    {
        [self setCheckboxChecked:YES];
    }
    else
    {
        [self setCheckboxChecked:NO];
    }
}

- (void) setCheckboxChecked:(BOOL)checked
{
    self.notifyMeButton.selected = checked;
}

- (BOOL) isValidEmail:(NSString *)checkString
{
    NSString *emailRegex = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void) onDismiss
{
    [self.emailTextField resignFirstResponder];
    [_delegate onSettingsSaved];
    //[self dismissViewControllerAnimated:YES completion:^{}];
}

- (void) setPopoverShown:(BOOL)shown
{
    if (shown)
    {
        self.popoverImage.alpha = 0.0f;
        self.popoverLabel.alpha = 0.0f;
        
        self.popoverImage.hidden = NO;
        self.popoverLabel.hidden = NO;
        
        [UIView animateWithDuration:0.4 animations:^{
            self.popoverImage.alpha = 1.0f;
            self.popoverLabel.alpha = 1.0f;
        }];
    }
    else
    {
        self.popoverImage.alpha = 0.0f;
        self.popoverLabel.alpha = 0.0f;
    }
    
    popoverShown = shown;
}

-(BOOL)hasShownToUserAtLeastOnce {
   // [[NSUserDefaults standardUserDefaults] b]
    //return [[NSUserDefaults standardUserDefaults] boolForKey:SETTING_HAS_SHOWN_SETTINGS_TO_USER];
    return NO;
}

@end
