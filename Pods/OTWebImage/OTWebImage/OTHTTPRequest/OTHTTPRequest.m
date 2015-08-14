//
//  OTHTTPRequest.m
//  OTHTTPRequestDemo
//
//  Created by openthread on 5/13/13.
//  Copyright (c) 2013 openthread. All rights reserved.
//

#import "OTHTTPRequest.h"

@implementation OTHTTPRequestUploadFile
- (id)init
{
    self = [super init];
    if (self) {
        self.fileName = @"fileName";
        self.name = @"name";
    }
    return self;
}
@end

@implementation NSMutableURLRequest (GetAndPostParams)

- (void)setUpGetParams:(NSDictionary *)dictionary
{
    NSMutableString *getString = [NSMutableString stringWithString:@"?"];
    for (id key in dictionary.allKeys)
    {
        if ([key isKindOfClass:[NSString class]])
        {
            NSString *value = dictionary[key];
            if ([value isKindOfClass:[NSString class]])
            {
                [getString appendString:[OTHTTPRequest urlEncode:key]];
                [getString appendString:@"="];
                [getString appendString:[OTHTTPRequest urlEncode:value]];
                if ([dictionary.allKeys lastObject] != key)
                {
                    [getString appendString:@"&"];
                }
            }
        }
    }
    
    NSString *urlString = self.URL.absoluteString;
    NSRange qouteRange = [urlString rangeOfString:@"?"];
    if (qouteRange.location != NSNotFound)
    {
        urlString = [urlString substringToIndex:qouteRange.location];
    }
    
    NSString *finalURLString = [urlString stringByAppendingString:getString];
    self.URL = [NSURL URLWithString:finalURLString];
}


- (void)setUpPostParams:(NSDictionary *)dictionary
{
    NSMutableString *postString = [NSMutableString string];
    for (id key in dictionary.allKeys)
    {
        if ([key isKindOfClass:[NSString class]])
        {
            NSString *value = dictionary[key];
            if ([value isKindOfClass:[NSString class]])
            {
                [postString appendString:[OTHTTPRequest urlEncode:key]];
                [postString appendString:@"="];
                [postString appendString:[OTHTTPRequest urlEncode:value]];
                
                if ([dictionary.allKeys lastObject] != key)
                {
                    [postString appendString:@"&"];
                }
            }
        }
    }
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [self setHTTPBody:postData];

    NSString *postLength = [NSString stringWithFormat:@"%tu", [postData length]];
    [self setValue:postLength forHTTPHeaderField:@"Content-Length"];

    [self setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [self setHTTPMethod:@"POST"];
}

//Multipart form data request with post params, and single file's data.
//Using NSUTF8StringEncoding.
- (void)setUpMultiPartFormDataRequestWithPostParams:(NSDictionary *)postParams file:(OTHTTPRequestUploadFile *)file
{
    [self setUpMultiPartFormDataRequestWithPostParams:postParams filesArray:@[file]];
}

//Multipart form data request with post params, and files' data.
//Each member of `filesArray` is an `OTHTTPRequestUploadFile`.
//Using NSUTF8StringEncoding.
- (void)setUpMultiPartFormDataRequestWithPostParams:(NSDictionary *)postParams filesArray:(NSArray *)filesArray
{
    [self setUpMultiPartFormDataRequestWithPostParams:postParams filesArray:filesArray encoding:NSUTF8StringEncoding];
}

//Multipart form data request with post params, and files' data.
//Each member of `filesArray` is an `OTHTTPRequestUploadFile`.
//Using specific string encoding.
- (void)setUpMultiPartFormDataRequestWithPostParams:(NSDictionary *)postParams filesArray:(NSArray *)filesArray encoding:(NSStringEncoding)encoding
{
    if (!encoding)
    {
        encoding = NSUTF8StringEncoding;
    }
    NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(encoding));
	
	// We don't bother to check if post data contains the boundary, since it's pretty unlikely that it does.
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
	NSString *stringBoundary = [NSString stringWithFormat:@"0xKhTmLbOuNdArY-%@",uuidString];
	
    if (![self.allHTTPHeaderFields.allKeys containsObject:@"Content-Type"])
    {
        [self setValue:[NSString stringWithFormat:@"multipart/form-data; charset=%@; boundary=%@", charset, stringBoundary] forHTTPHeaderField:@"Content-Type"];
    }
    
    NSMutableData *postBodyData = [NSMutableData data];
    [postBodyData appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:encoding]];
	
	// Adds post data
	NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary];
	NSUInteger i=0;
	for (NSString *eachKey in postParams.allKeys)
    {
        [postBodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",eachKey] dataUsingEncoding:encoding]];
        [postBodyData appendData:[postParams[eachKey] dataUsingEncoding:encoding]];
		i++;
		if (i != [postParams.allKeys count] || [filesArray count] > 0)
        {
            //Only add the boundary if this is not the last item in the post body
            [postBodyData appendData:[endItemBoundary dataUsingEncoding:encoding]];
		}
	}
	
	// Adds files to upload
	i=0;
	for (OTHTTPRequestUploadFile *eachFile in filesArray)
    {
        [postBodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", eachFile.name, eachFile.fileName] dataUsingEncoding:encoding]];

        [postBodyData appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", eachFile.contentType ? eachFile.contentType : @"application/octet-stream"] dataUsingEncoding:encoding]];
		
		NSData *data = eachFile.fileData;
		if ([data isKindOfClass:[NSData class]])
        {
            [postBodyData appendData:data];
		}
		i++;
		// Only add the boundary if this is not the last item in the post body
		if (i != [filesArray count])
        {
            [postBodyData appendData:[endItemBoundary dataUsingEncoding:encoding]];
		}
	}
    [postBodyData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:encoding]];
    [self setHTTPBody:postBodyData];
    
    NSString *postLength = [NSString stringWithFormat:@"%tu", [postBodyData length]];
    [self setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [self setHTTPMethod:@"POST"];
}

@end

@interface OTHTTPRequest()<NSURLConnectionDataDelegate>
@end

@implementation OTHTTPRequest
{
    NSURLRequest *_request;
    NSURLResponse *_response;
    
    NSMutableData *_data;
    NSURLConnection *_connection;
}

#pragma mark - Class Methods

+ (NSString *)urlEncode:(NSString *)stringToEncode
{
    return [self urlEncode:stringToEncode usingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)urlEncode:(NSString *)stringToEncode usingEncoding:(NSStringEncoding)encoding
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)stringToEncode,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));
}

+ (NSString*)urlDecode:(NSString *)stringToDecode
{
    return [self urlDecode:stringToDecode usingEncoding:NSUTF8StringEncoding];
}

+ (NSString*)urlDecode:(NSString *)stringToDecode usingEncoding:(NSStringEncoding)encoding
{
    return (__bridge_transfer NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                  (__bridge CFStringRef)stringToDecode,
                                                                                                  (CFStringRef)@"",
                                                                                                  CFStringConvertNSStringEncodingToEncoding(encoding));
}

+ (NSDictionary *)parseGetParamsFromURLString:(NSString *)urlString
{
    if (!urlString)
    {
        return nil;
    }
    NSRange queryRange = [urlString rangeOfString:@"?"];
    if (queryRange.location == NSNotFound)
    {
        return nil;
    }
    
    NSString *subString = [urlString substringFromIndex:queryRange.location + queryRange.length];
    NSArray *components = [subString componentsSeparatedByString:@"&"];
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    for (NSString *string in components)
    {
        NSRange equalRange = [string rangeOfString:@"="];
        if (equalRange.location == NSNotFound)
        {
            continue;
        }
        NSString *key = [string substringToIndex:equalRange.location];
        NSString *value = [string substringFromIndex:equalRange.location + equalRange.length];
        [resultDic setObject:value forKey:key];
    }
    
    NSDictionary *returnDic = [NSDictionary dictionaryWithDictionary:resultDic];
    return returnDic;
}

#pragma mark - Init Methods

//Create request with a NSURLRequest.
- (id)initWithNSURLRequest:(NSURLRequest *)request
{
    self = [super init];
    if (self)
    {
        _request = request;
        self.isLowPriority = YES;
        self.shouldClearCachedResponseWhenRequestDone = YES;
    }
    return self;
}

- (void)dealloc
{
    [self cancel];
}

#pragma mark - Request and response

- (NSURLRequest *)request
{
    return _request;
}

- (NSURLResponse *)response
{
    return _response;
}

- (NSInteger)responseStatusCode
{
    if ([_response isKindOfClass:[NSHTTPURLResponse class]])
    {
        return [(NSHTTPURLResponse *)_response statusCode];
    }
    return 0;
}

- (NSData *)responseData
{
    if (_data == nil)
    {
        return nil;
    }
    NSData *returnData = [NSData dataWithData:_data];
    return returnData;
}

- (NSString *)responseString
{
    NSString *responseEncoding = [self.response textEncodingName];
    NSString *responseString = nil;
    if (responseEncoding)
    {
        NSData *responseData = [self responseData];
        responseString = [[NSString alloc]initWithData:responseData
                                              encoding:CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((CFStringRef)responseEncoding))];
    }
    else
    {
        responseString = [self responseUTF8String];
    }
    return responseString;
}

- (NSString *)responseUTF8String
{
    NSData *responseData = [self responseData];
    NSString *utf8String = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    return utf8String;
}

#pragma mark - Start and cancel

- (void)cancel
{
    [_connection cancel];
    _connection = nil;
    _data = nil;
    _response = nil;
}

- (void)start
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if (!_connection)
    {
        [self beginConnection];
    }
}

- (void)beginConnection
{
    _data = [NSMutableData data];
    _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:NO];
    if (!self.isLowPriority)
    {
        [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    [_connection start];
}

#pragma mark - NSURLConnectionDataDelegate Callbacks

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _response = response;
    if ([self.delegate respondsToSelector:@selector(otHTTPRequest:didReceiveResponse:)])
    {
        [self.delegate otHTTPRequest:self didReceiveResponse:response];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
    if ([self.delegate respondsToSelector:@selector(otHTTPRequest:dataUpdated:)])
    {
        [self.delegate otHTTPRequest:self dataUpdated:data];
    }
    if ([self.delegate respondsToSelector:@selector(otHTTPRequest:dataUpdated:totalData:)])
    {
        NSData *callbackData = [NSData dataWithData:_data];
        [self.delegate otHTTPRequest:self dataUpdated:data totalData:callbackData];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([self.delegate respondsToSelector:@selector(otHTTPRequestFinished:)])
    {
        [self.delegate otHTTPRequestFinished:self];
    }
    if (self.shouldClearCachedResponseWhenRequestDone)
    {
        if (_request.URL)
        {
            [[NSURLCache sharedURLCache] removeCachedResponseForRequest:_request];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(otHTTPRequestFailed:error:)])
    {
        [self.delegate otHTTPRequestFailed:self error:error];
    }
    if (self.shouldClearCachedResponseWhenRequestDone)
    {
        if (_request.URL)
        {
            [[NSURLCache sharedURLCache] removeCachedResponseForRequest:_request];
        }
    }
    [self cancel];
}

@end
