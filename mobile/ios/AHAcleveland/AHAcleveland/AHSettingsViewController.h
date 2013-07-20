//
//  AHSettingsViewController.h
//  AHAcleveland
//
//  Created by AnyaTheMac on 7/20/13.
//  Copyright (c) 2013 Bill Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AHSettingsViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIButton *notifyMeButton;
@property (nonatomic, strong) IBOutlet UILabel *popoverLabel;
@property (nonatomic, strong) IBOutlet UIImageView *popoverImage;

@end
