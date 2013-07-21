#import "AppDelegate.h"
#import "AHImagePickerController.h"
#import "AHLegaleseController.h"

@implementation AppDelegate

AHImagePickerController *imagePickerController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tabBarController = [[UITabBarController alloc] init];
    imagePickerController = [[AHImagePickerController alloc] init];

    self.window.rootViewController = imagePickerController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
