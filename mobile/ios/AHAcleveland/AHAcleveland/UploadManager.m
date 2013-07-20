//
//  UploadManager.m
//  AHAcleveland
//
//  Created by Bill Davis on 7/19/13.
//  Copyright (c) 2013 Bill Davis. All rights reserved.
//

#import "UploadManager.h"

@implementation UploadManager

static UploadManager *sharedSingleton = nil;

+ (UploadManager*)instance
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






-(void)testUpload
{
    NSString* deviceId = ([(NSUUID*)[NSUUID UUID] UUIDString]);
    
    NSString* email = @"sample@gmail.com";
    
    NSString* fileStorageDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* placeholderPath = [fileStorageDirectory stringByAppendingPathComponent:@"placeholder.jpg"];
    
    
    NSURL* url = [NSURL fileURLWithPath:placeholderPath];
   
    
    [self uploadImageUrl:url withEmail:email andDeviceId:deviceId];
    
}


-(void)uploadImageUrl:(NSURL*)imageUrl withEmail:(NSString*)emailAddress andDeviceId:(NSString*)device
{
    
    NSData* imageData = [self retrieveImageData:imageUrl];
    
    
    NSURLRequest* request = [self configureRequestWithData:imageData andEmail:emailAddress andDevice:device];
    
    
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    [conn start];
    
    
    
}

-(NSURLRequest*)configureRequestWithData:(NSData*)imageData andEmail:(NSString*)email andDevice:(NSString*)deviceId
{
    
    NSString* imageName = [NSString stringWithFormat:@"%@.jpg",([(NSUUID*)[NSUUID UUID] UUIDString])];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:UPLOAD_SERVICE_URL]];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *myboundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",myboundary];
    [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    NSMutableData *postData = [NSMutableData data]; //[NSMutableData dataWithCapacity:[data length] + 512];
    
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:deviceId forKey:@"device"];
    [_params setObject:email forKey:@"email"];
    
    
    for (NSString *param in _params) {
        [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", imageName]dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[NSData dataWithData:imageData]];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [urlRequest setHTTPBody:postData];
    
    return urlRequest;

}


-(NSData*)retrieveImageData:(NSURL*)urlToFile
{
    NSData* data = [NSData dataWithContentsOfURL:urlToFile];
    
    return data;
}

-(void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    
    [userInfo setValue:[NSNumber numberWithInt:totalBytesWritten] forKey:UPLOAD_TOTALBYTESSOFAR];
    [userInfo setValue:[NSNumber numberWithInt:totalBytesExpectedToWrite] forKey:UPLOAD_TOTALBYTESEXPECTED];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UPLOAD_PROGRESS object:nil userInfo:userInfo];
    
    NSLog(@"progress sent");
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UPLOAD_FAIL object:nil userInfo:nil];
    
    NSLog(@"upload failed");
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    

    [[NSNotificationCenter defaultCenter] postNotificationName:UPLOAD_SUCCESS object:nil userInfo:nil];
    
    NSLog(@"upload finished successfully");
}



@end
