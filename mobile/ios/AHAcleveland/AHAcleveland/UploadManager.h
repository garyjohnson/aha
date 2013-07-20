//
//  UploadManager.h
//  AHAcleveland
//
//  Created by Bill Davis on 7/19/13.
//  Copyright (c) 2013 Bill Davis. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UPLOAD_SERVICE_URL @"http://172.16.0.160:8888/GiveCamp/webroot/webservices/uploadimage.php"
#define UPLOAD_FAIL @"UPLOAD_FAIL"
#define UPLOAD_SUCCESS @"UPLOAD_SUCCESS"

@interface UploadManager : NSObject <NSURLConnectionDelegate>


+ (UploadManager*)instance;


-(void)uploadImage:(NSURL*)imageUrl withEmail:(NSString*)emailAddress andDeviceId:(NSString*)device;

-(void)testUpload;
@end
