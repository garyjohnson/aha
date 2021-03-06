//
//  UploadManager.h
//  AHAcleveland
//
//  Created by Bill Davis on 7/19/13.
//  Copyright (c) 2013 Bill Davis. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UPLOAD_SERVICE_URL @"http://ec2-54-227-145-112.compute-1.amazonaws.com/aha/webservices/uploadimage.php"
#define UPLOAD_FAIL @"UPLOAD_FAIL"
#define UPLOAD_SUCCESS @"UPLOAD_SUCCESS"
#define UPLOAD_PROGRESS @"UPLOAD_PROGRESS"
#define UPLOAD_TOTALBYTESEXPECTED @"UPLOAD_TOTALBYTESEXPECTED"
#define UPLOAD_TOTALBYTESSOFAR @"UPLOAD_TOTALBYTESSOFAR"

@interface UploadManager : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>


+ (UploadManager*)instance;


-(void)uploadImageUrl:(NSURL*)imageUrl withEmail:(NSString*)emailAddress andDeviceId:(NSString*)device;

-(void)testUpload;
@end
