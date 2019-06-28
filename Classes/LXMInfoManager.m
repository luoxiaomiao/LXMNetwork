//
//  LXMInfoManager.m
//  LXMNetwork
//
//  Created by luoxiaomiao on 2019/5/30.
//  Copyright © 2019 omiao. All rights reserved.
//

#import "LXMInfoManager.h"
#import "LXMNetworkDriver.h"
#import <YYModel/YYModel.h>
#import <AFNetworking/AFNetworking.h>

@interface LXMInfoManager()<LXMNetworkDriverDelegate, LXMNetworkSerialProtocol>

@end

@implementation LXMInfoManager

+ (instancetype)shareInstance {
    static LXMInfoManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)setupNetworkEngine {
    [LXMNetworkDriver shareInstance].delegate = self;
    [LXMNetworkDriver shareInstance].serializer = self;
}

- (nonnull NSURLSessionDataTask *)GET:(nonnull NSString *)URLString
                                 head:(nonnull NSDictionary *)head
                           parameters:(nonnull id)parameters
                              success:(nonnull void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success
                              failure:(nonnull void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [head enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    return [manager GET:URLString parameters:parameters progress:nil success:success failure:failure];
}

- (nonnull NSURLSessionDataTask *)POST:(nonnull NSString *)URLString
                                  head:(nonnull NSDictionary *)head
                            parameters:(nonnull id)parameters
                               success:(nonnull void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success
                               failure:(nonnull void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [head enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    return [manager POST:URLString parameters:parameters progress:nil success:success failure:failure];
}

- (nonnull NSURLSessionDataTask *)POST:(nonnull NSString *)URLString
                                  head:(nonnull NSDictionary *)head
                         JSONParameter:(nonnull NSDictionary *)parameters
                               success:(nonnull void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success
                               failure:(nonnull void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [head enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    return [manager POST:URLString parameters:parameters progress:nil success:success failure:failure];
}

- (nonnull NSDictionary *)defaultHeadForRequest:(nonnull LXMBaseRequest *)request { 
    return @{};
}

- (nonnull NSDictionary *)defaultParamsForRequest:(nonnull LXMBaseRequest *)request { 
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
