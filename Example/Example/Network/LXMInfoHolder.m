//
//  LXMInfoHolder.m
//  Example
//
//  Created by luoxiaomiao on 2019/8/6.
//  Copyright © 2019 omiao. All rights reserved.
//

#import "LXMInfoHolder.h"
#import "LXMHttpClient.h"
#import <YYModel/YYModel.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import <LXMNetwork.h>

@interface LXMInfoHolder()<LXMNetworkDriverDelegate, LXMNetworkSerialProtocol>

@end

@implementation LXMInfoHolder

+ (instancetype)shareInstance {
    static LXMInfoHolder *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)setupNetworkDriver {
    [LXMNetworkDriver shareInstance].delegate = self;
    [LXMNetworkDriver shareInstance].serializer = self;
}

- (nullable NSURLSessionDataTask *)GET:(nonnull NSString *)URLString
                                  head:(nonnull NSDictionary *)head
                            parameters:(nonnull id)parameters
                               success:(nonnull void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success
                               failure:(nonnull void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure {
    LXMHttpClient *client = [LXMHttpClient client];
    [head enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [client.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    return [client GET:URLString parameters:parameters success:success failure:failure];
}

- (nullable NSURLSessionDataTask *)POST:(nonnull NSString *)URLString
                                   head:(nonnull NSDictionary *)head
                             parameters:(nonnull id)parameters
                                success:(nonnull void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success
                                failure:(nonnull void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure {
    LXMHttpClient *client = [LXMHttpClient client];
    [head enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [client.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    return [client POST:URLString parameters:parameters success:success failure:failure];
}

- (nullable NSURLSessionDataTask *)POST:(nonnull NSString *)URLString
                                   head:(nonnull NSDictionary *)head
                          JSONParameter:(nonnull NSDictionary *)parameters
                                success:(nonnull void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success
                                failure:(nonnull void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure {
    
    LXMHttpClient *client = [LXMHttpClient client];
    client.requestSerializer = [AFJSONRequestSerializer serializer];
    [head enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [client.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    return [client POST:URLString parameters:parameters success:success failure:failure];
}



- (nullable NSURLSessionDataTask *)POST:(nonnull NSString *)URLString
                                   head:(nonnull NSDictionary *)head
                             parameters:(nonnull id)parameters
              constructingBodyWithBlock:(nonnull void (^)(id<AFMultipartFormData> _Nonnull))block
                               progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                success:(nonnull void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success
                                failure:(nonnull void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure {
    LXMHttpClient *client = [LXMHttpClient client];
    [head enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [client.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    return [client POST:URLString parameters:parameters constructingBodyWithBlock:block progress:uploadProgress success:success failure:failure];
}

- (nonnull NSDictionary *)defaultHeadForRequest:(nonnull LXMBaseRequest *)request {
    //设置公共请求头
    return @{};
}


- (nonnull NSDictionary *)defaultParamsForRequest:(nonnull LXMBaseRequest *)request {
    //设置公参
    return @{};
}

- (nonnull NSString *)defaultSchmeForRequest:(nonnull LXMBaseRequest *)request {
    return @"http";
}

- (nonnull id)lxmSerializationWithJSON:(nonnull id)JSON class:(nonnull Class)objcClass {
    if ([JSON isKindOfClass:[NSDictionary class]]) {
        id obj = [objcClass yy_modelWithJSON:JSON];
        return obj;
    } else if([JSON isKindOfClass:[NSArray class]]) {
        return [NSArray yy_modelArrayWithClass:objcClass json:JSON];
    } else {
        return nil;
    }
}

@end
