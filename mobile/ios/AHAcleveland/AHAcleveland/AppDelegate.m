#import "AppDelegate.h"
#import "AHImagePickerController.h"
#import "AHLegaleseController.h"

@implementation AppDelegate

AHImagePickerController *imagePickerController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tabBarController = [[UITabBarController alloc] init];
    imagePickerController = [[AHImagePickerController alloc] init];

    
    if(![self hasInstallationId])
    {
        [self generateAndSetInstallationId];
    }
    
    self.window.rootViewController = imagePickerController;
    [self.window makeKeyAndVisible];
    return YES;
}

-(NSString*)installationId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* installationId = [defaults stringForKey:DEFAULTS_INSTALLATIONID];
    
    return installationId;
    
}

-(bool)hasInstallationId
{
    if([self installationId] != nil)
    {
        return true;
    }
    
    return false;
}

-(void)generateAndSetInstallationId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setValue:[(NSUUID*)[NSUUID UUID] UUIDString] forKey:DEFAULTS_INSTALLATIONID];
    
    [defaults synchronize];
    
    
}

@end
