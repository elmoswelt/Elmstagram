//
//  MCNetworkManager.m
//  Elmstagram
//
//  Created by Elmar Tampe on 24/09/14.
//  Copyright (c) 2014 Elmar Tampe. All rights reserved.
//

#import "MCNetworkManager.h"


@implementation MCNetworkManager


// ------------------------------------------------------------------------------------------
#pragma mark - Image Uploading
// ------------------------------------------------------------------------------------------
+ (void)uploadImage:(UIImage *)image
       successBlock:(void (^)(NSURL * url))successBlock
       failureBlock:(void (^)(NSError *error))failureBlock
{
    NSURLSession *urlSession = [MCNetworkManager urlSession];
    NSURLRequest *urlRequest = [MCNetworkManager urlRequest];
    NSMutableData *urlRequestBody = [MCNetworkManager requestBodyWithImageData:UIImagePNGRepresentation(image)];
    
    NSURLSessionUploadTask *uploadTask = [urlSession uploadTaskWithRequest:urlRequest
                                                                  fromData:urlRequestBody
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              if (error == nil)
                                              {
                                                  if (successBlock)
                                                  {
                                                      if (((NSHTTPURLResponse *) response).statusCode == 200)
                                                      {
                                                          successBlock([MCNetworkManager imageURLFromResponseJSONData:data]);
                                                      }
                                                      else
                                                      {
                                                          if (failureBlock)
                                                          {
                                                              failureBlock([MCNetworkManager uploadError]);
                                                          }
                                                      }
                                                  }
                                              }
                                              else
                                              {
                                                  if (failureBlock)
                                                  {
                                                      failureBlock([MCNetworkManager uploadError]);
                                                  }
                                              }
                                          }];
    
    [uploadTask resume];
}


// ------------------------------------------------------------------------------------------
#pragma mark - Generic Error Handling
// ------------------------------------------------------------------------------------------
+ (NSError *)uploadError
{
    return [NSError errorWithDomain:@"com.mountaincoders.elmstagram" code:10001 userInfo:nil];
}


// ------------------------------------------------------------------------------------------
#pragma mark - NSURLSession
// ------------------------------------------------------------------------------------------
+ (NSURLSession *)urlSession
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

    return session;
}


// ------------------------------------------------------------------------------------------
#pragma mark - NSURLRequest
// ------------------------------------------------------------------------------------------
+ (NSURLRequest *)urlRequest
{
    NSURL *url = [NSURL URLWithString:@"https://api.imgur.com/3/upload.json"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", [MCNetworkManager boundary]];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"Client-ID b7a47b1ff0c9934"] forHTTPHeaderField:@"Authorization"];
    
    return request;
}


// ------------------------------------------------------------------------------------------
#pragma mark - RequestBody
// ------------------------------------------------------------------------------------------
+ (NSMutableData *)requestBodyWithImageData:(NSData *)imageData
{
    NSMutableData *requestBody = [[NSMutableData alloc] init];

    [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", [MCNetworkManager boundary]]
                             dataUsingEncoding:NSUTF8StringEncoding]];
    
    [requestBody appendData:[@"Content-Disposition: attachment; name=\"image\"; filename=\".tiff\"\r\n"
                             dataUsingEncoding:NSUTF8StringEncoding]];
    
    [requestBody appendData:[@"Content-Type: application/octet-stream\r\n\r\n"
                             dataUsingEncoding:NSUTF8StringEncoding]];
    
    [requestBody appendData:[NSData dataWithData:imageData]];
    
    [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [requestBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", [MCNetworkManager boundary]]
                             dataUsingEncoding:NSUTF8StringEncoding]];
    
    return requestBody;
}


// ------------------------------------------------------------------------------------------
#pragma mark - Multipart Boundary
// ------------------------------------------------------------------------------------------
+ (NSString *)boundary
{
    return @"---------------------------0983745982375409872438752038475287";
}


// ------------------------------------------------------------------------------------------
#pragma mark - JSON Mapping
// ------------------------------------------------------------------------------------------
+ (NSURL *)imageURLFromResponseJSONData:(NSData *)responseData
{
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:nil];
    
    return [NSURL URLWithString:[[responseDictionary valueForKey:@"data"] valueForKey:@"link"]];
}

@end
