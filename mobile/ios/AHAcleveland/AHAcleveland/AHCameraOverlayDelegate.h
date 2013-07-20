#import <Foundation/Foundation.h>

@protocol AHCameraOverlayDelegate<NSObject>

-(void)onShutterPressed;
-(void)onUsePhotoPressed;
-(void)onTossPhotoPressed;

@end
