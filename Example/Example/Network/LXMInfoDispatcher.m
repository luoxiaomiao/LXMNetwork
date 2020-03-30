//
//  LXMInfoDispatcher.m
//  Example
//
//  Created by luoxiaomiao on 2019/8/6.
//  Copyright © 2019 omiao. All rights reserved.
//

#import "LXMInfoDispatcher.h"
#import "LXMHTTPSessionManager.h"
#import <YYModel/YYModel.h>
#import <AFNetworking/AFNetworking.h>
#import <LXMNetwork.h>

@interface LXMInfoDispatcher()<LXMNetworkDriverDelegate, LXMNetworkSerialProtocol>

@end

@implementation LXMInfoDispatcher

+ (instancetype)shareInstance {
    static LXMInfoDispatcher *instance;
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

- (nonnull NSURLSessionDataTask *)GET:(nonnull NSString *)URLString
                                 head:(nonnull NSDictionary *)head
                           parameters:(nonnull id)parameters
                              success:(nonnull void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success
                              failure:(nonnull void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure {
    LXMHTTPSessionManager *client = [LXMHTTPSessionManager client];
    [head enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [client.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    return [client GET:URLString parameters:parameters success:success failure:failure];
}

- (nonnull NSURLSessionDataTask *)POST:(nonnull NSString *)URLString
                                  head:(nonnull NSDictionary *)head
                            parameters:(nonnull id)parameters
                               success:(nonnull void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success
                               failure:(nonnull void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure {
    LXMHTTPSessionManager *client = [LXMHTTPSessionManager client];
    [head enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [client.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    return [client POST:URLString parameters:parameters success:success failure:failure];
}

- (nonnull NSURLSessionDataTask *)POST:(nonnull NSString *)URLString
                                  head:(nonnull NSDictionary *)head
                         JSONParameter:(nonnull NSDictionary *)parameters
                               success:(nonnull void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success
                               failure:(nonnull void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure {
    
    LXMHTTPSessionManager *client = [LXMHTTPSessionManager client];
    client.requestSerializer = [AFJSONRequestSerializer serializer];
    [head enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [client.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    return [client POST:URLString parameters:parameters success:success failure:failure];
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
