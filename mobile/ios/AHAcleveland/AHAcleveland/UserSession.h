#import <Foundation/Foundation.h>

@interface UserSession : NSObject

+ (NSString*) getEmail;
+ (BOOL) setEmail:(NSString*)email;

@end
