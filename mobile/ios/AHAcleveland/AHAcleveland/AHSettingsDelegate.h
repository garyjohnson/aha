#import <Foundation/Foundation.h>

@protocol AHSettingsDelegate <NSObject>

- (void)onSettingsSaved:(BOOL)isFirstTimeShown;

@end