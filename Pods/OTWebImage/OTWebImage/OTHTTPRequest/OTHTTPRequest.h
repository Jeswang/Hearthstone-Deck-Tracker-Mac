//
//  OTHTTPRequest.h
//  OTHTTPRequestDemo
//
//  Created by openthread on 5/13/13.
//  Copyright (c) 2013 openthread. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OTHTTPRequest;

@interface OTHTTPRequestUploadFile : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSString *contentType;
@property (nonatomic, retain) NSData *fileData;
@end

@interface NSMutableURLRequest (GetAndPostParams)

//Simple request with get params.
- (void)setUpGetParams:(NSDictionary *)dictionary;

//Simple request with post params.
- (void)setUpPostParams:(NSDictionary *)postParams;

//Multipart form data request with post params, and single file's data.
//Using NSUTF8StringEncoding.
- (void)setUpMultiPartFormDataRequestWithPostParams:(NSDictionary *)postParams file:(OTHTTPRequestUploadFile *)file;

//Multipart form data request with post params, and files' data.
//Each member of `filesArray` is an `OTHTTPRequestUploadFile`.
//Using NSUTF8StringEncoding.
- (void)setUpMultiPartFormDataRequestWithPostParams:(NSDictionary *)postParams filesArray:(NSArray *)filesArray;

//Multipart form data request with post params, and files' data.
//Each member of `filesArray` is an `OTHTTPRequestUploadFile`.
//Using specific string encoding.
- (void)setUpMultiPartFormDataRequestWithPostParams:(NSDictionary *)postParams filesArray:(NSArray *)filesArray encoding:(NSStringEncoding)encoding;

@end


@protocol OTHTTPRequestDelegate <NSObject>

@required
- (void)otHTTPRequestFinished:(OTHTTPRequest *)request;
- (void)otHTTPRequestFailed:(OTHTTPRequest *)request error:(NSError *)error;

@optional
- (void)otHTTPRequest:(OTHTTPRequest *)request didReceiveResponse:(NSURLResponse *)response;
- (void)otHTTPRequest:(OTHTTPRequest *)request dataUpdated:(NSData *)data;
- (void)otHTTPRequest:(OTHTTPRequest *)request dataUpdated:(NSData *)data totalData:(NSData *)totalData;

@end

@interface OTHTTPRequest : NSObject

#pragma mark - Class Methods

+ (NSString *)urlEncode:(NSString *)stringToEncode;//Encode with UTF8
+ (NSString *)urlEncode:(NSString *)stringToEncode usingEncoding:(NSStringEncoding)encoding;

+ (NSString*)urlDecode:(NSString *)stringToDecode;//Decode with UTF8
+ (NSString*)urlDecode:(NSString *)stringToDecode usingEncoding:(NSStringEncoding)encoding;

+ (NSDictionary *)parseGetParamsFromURLString:(NSString *)urlString;

#pragma mark - Init Methods

//Create request with a NSURLRequest.
- (id)initWithNSURLRequest:(NSURLRequest *)request;

@property (nonatomic, weak) id<OTHTTPRequestDelegate> delegate;
@property (nonatomic, retain) id userInfo;

#pragma mark - Options

//Set if this is a low priority request. Set this property before call `start` to take effect.
//Default value is `YES`.
//When set to `NO`, request will be started at default priority.
@property (nonatomic,assign) BOOL isLowPriority;

//To avoid memory issues, default is YES.
@property (nonatomic, assign) BOOL shouldClearCachedResponseWhenRequestDone;

#pragma mark - Request and response

@property (nonatomic,readonly) NSURLRequest *request;

//Returns nil if response haven't reached yet.
@property (nonatomic,readonly) NSURLResponse *response;

//Returns 0 if http url response haven't reached yet.
@property (nonatomic, readonly) NSInteger responseStatusCode;

//Get responsed data
- (NSData *)responseData;

//Get responsed string using response's encoding. If response has no encoding info, use UTF8 encoding.
- (NSString *)responseString;

//Get responsed string using UTF8 encoding.
- (NSString *)responseUTF8String;

#pragma mark - Start and cancel

//cancel request
- (void)cancel;

//begin request
- (void)start;

@end
