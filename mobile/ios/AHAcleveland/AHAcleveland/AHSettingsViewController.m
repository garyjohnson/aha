//
//  AHSettingsViewController.m
//  AHAcleveland
//
//  Created by AnyaTheMac on 7/20/13.
//  Copyright (c) 2013 Bill Davis. All rights reserved.
//

#import "AHSettingsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UserSession.h"

@interface AHSettingsViewController ()
{
    int originalOffset;
    BOOL popoverShown;
}

@end

@implementation AHSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom  initialization
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            [self showErrorWithMessage:@""];
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
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void) setPopoverShown:(BOOL)shown
{
    self.popoverImage.hidden = !shown;
    self.popoverLabel.hidden = !shown;
    
    popoverShown = shown;
}


@end
