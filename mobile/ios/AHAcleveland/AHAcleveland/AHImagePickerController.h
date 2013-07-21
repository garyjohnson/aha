#import <UIKit/UIKit.h>
#import "AHCameraOverlayDelegate.h"
#import "AHLegaleseDelegate.h"
#import "AHSettingsDelegate.h"

@interface AHImagePickerController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, AHCameraOverlayDelegate, AHLegaleseDelegate, AHSettingsDelegate>

@end
