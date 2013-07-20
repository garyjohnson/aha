//
//  AHEULAManager.h
//  AHAcleveland
//
//  Created by Bill Davis on 7/20/13.
//  Copyright (c) 2013 Bill Davis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AHEULAManager : NSObject

+ (AHEULAManager*)instance;

-(bool)hasAgreedToEula;
-(void)setEulaAgreed;


@end
