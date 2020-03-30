//
//  LXMHttpClient.m
//  Example
//
//  Created by luoxiaomiao on 2019/8/6.
//  Copyright © 2019 omiao. All rights reserved.
//

#import "LXMHttpClient.h"

#define  TimeOut 60.0f

@implementation LXMHttpClient

+ (instancetype)client {
    NSURLSessionConfiguration *configration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    configration.timeoutIntervalForRequest = TimeOut;
    configration.timeoutIntervalForResource = TimeOut;
    LXMHttpClient *client = [[LXMHttpClient alloc] initWithSessionConfiguration:configration];
    client.requestSerializer = [AFHTTPRequestSerializer serializer];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.removesKeysWithNullValues = YES;
    client.responseSerializer = responseSerializer;
    client.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    client.securityPolicy.allowInvalidCertificates = YES;
    client.securityPolicy.validatesDomainName = NO;
    client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                        @"application/x-javascript",
                                                        @"application/json",
                                                        @"text/plain",
                                                        @"text/html",
                                                        @"text/json",
                                                        @"text/javascript",
                                                        @"application/x-msgpack", nil];
    // 这里可增加HTTPS证书验证设置
    return client;
}

- (void)setTimeOut:(NSInteger)timeOut {
    _timeOut = timeOut;
    if (_timeOut != 0) {
        [self.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        self.requestSerializer.timeoutInterval = _timeOut;
        [self.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
}

- (NSURLSessionDataTask *)requestWithMethod:(NSString *)method
                                        url:(NSString *)URLString
                                 parameters:(id)parameters
                                      guard:(BOOL)guard
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    // 这里用于后续处理成功和失败回调处理
    
    if ([[method uppercaseString] isEqualToString:@"GET"]) {
        return [super GET:URLString parameters:parameters progress:nil success:success failure:failure];
    } else if ([[method uppercaseString] isEqualToString:@"POST"]) {
        return [super POST:URLString parameters:parameters progress:nil success:success failure:failure];
    } else {
        NSAssert(NO, @"requestWithMethod 不支持");
        if (failure) {
            failure(nil, nil);
        }
        return nil;
    }
}

- (NSURLSessionDataTask *)requestWithMethod:(NSString *)method
                                        url:(NSString *)URLString
                                 parameters:(id)parameters
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    return [self requestWithMethod:method url:URLString parameters:parameters guard:YES success:success failure:failure];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                      failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    return [self requestWithMethod:@"GET" url:URLString parameters:parameters success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                       failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    return [self requestWithMethod:@"POST" url:URLString parameters:parameters success:success failure:failure];
}

- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
                                             progress:(void (^)(NSProgress * _Nonnull))downloadProgressBlock
                                          destination:(NSURL * _Nonnull (^)(NSURL * _Nonnull, NSURLResponse * _Nonnull))destination
                                    completionHandler:(void (^)(NSURLResponse * _Nonnull, NSURL * _Nullable, NSError * _Nullable))completionHandler {
    return [super downloadTaskWithRequest:request progress:downloadProgressBlock destination:destination completionHandler:completionHandler];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block
                      progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                       failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    return [super POST:URLString parameters:parameters constructingBodyWithBlock:block progress:uploadProgress success:success failure:failure];
}


@end
