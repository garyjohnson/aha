#import "UserSession.h"
#import "KeychainItemWrapper.h"

#define KEYCHAIN_ID @"com.AHA"

@implementation UserSession

+ (NSString*) getEmail
{
    @try
    {
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:KEYCHAIN_ID accessGroup:nil];
        NSString *email = [wrapper objectForKey:(__bridge id)kSecValueData];
        
        return email;
    }
    @catch (NSException *exception)
    {
        return nil;
    }
}

+ (BOOL) setEmail:(NSString*)email
{
    @try
    {
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:KEYCHAIN_ID accessGroup:nil];
        
        if (email.length > 0)
        {
            [wrapper setObject:email forKey:(__bridge id)kSecValueData];
        }
        else
        {
            [wrapper resetKeychainItem];
        }
        
        
        return YES;
    }
    @catch (NSException *exception)
    {
        return NO;
    }
    
}

@end
