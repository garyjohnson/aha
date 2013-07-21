#import <UIKit/UIKit.h>

#define DEFAULTS_INSTALLATIONID @"DEFAULTS_INSTALLATIONID"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

-(NSString*)installationId;

@end
