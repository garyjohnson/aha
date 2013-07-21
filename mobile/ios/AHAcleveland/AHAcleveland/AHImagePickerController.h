#import <UIKit/UIKit.h>
#import "AHCameraOverlayDelegate.h"
#import "AHLegaleseDelegate.h"

@interface AHImagePickerController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, AHCameraOverlayDelegate, AHLegaleseDelegate>

@end
