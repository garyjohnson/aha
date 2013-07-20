//
//  UploadManager.h
//  AHAcleveland
//
//  Created by Bill Davis on 7/19/13.
//  Copyright (c) 2013 Bill Davis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadManager : NSObject <NSURLConnectionDelegate>


+ (UploadManager*)instance;


-(void)uploadImage:(NSURL*)imageUrl withEmail:(NSString*)emailAddress andDeviceId:(NSString*)device;

-(void)testUpload;
@end
