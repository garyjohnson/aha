//
//  AHEULAManager.m
//  AHAcleveland
//
//  Created by Bill Davis on 7/20/13.
//  Copyright (c) 2013 Bill Davis. All rights reserved.
//

#import "AHEULAManager.h"

@implementation AHEULAManager

static AHEULAManager *sharedSingleton = nil;

+ (AHEULAManager*)instance
{
    if (sharedSingleton == nil) {
        sharedSingleton = [[super allocWithZone:NULL] init];
        
    }
    return sharedSingleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self instance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
    
}


-(bool)hasAgreedToEula
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString* EULAKey = [NSString stringWithFormat:@"EULA_READ_AND_AGREED_%@", build];
    bool hasAgreedToEULA = [defaults boolForKey:EULAKey];
    
    return hasAgreedToEULA;
}

-(void)setEulaAgreed
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString* EULAKey = [NSString stringWithFormat:@"EULA_READ_AND_AGREED_%@", build];
    
    [defaults setBool:true forKey:EULAKey];
    [defaults synchronize];
    

}

@end
