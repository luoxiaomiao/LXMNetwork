//
//  LXMNetworkDriver.h
//  LXMNetwork
//
//  Created by luoxiaomiao on 2019/5/29.
//  Copyright © 2019 omiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LXMBaseRequest;
@protocol AFMultipartFormData;

@protocol LXMNetworkDriverDelegate <NSObject>

- (NSDictionary *)defaultHeadForRequest:(LXMBaseRequest *)request;

- (NSDictionary *)defaultParamsForRequest:(LXMBaseRequest *)request;

- (NSString *)defaultSchmeForRequest:(LXMBaseRequest *)request;

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                         head:(NSDictionary *)head
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                         head:(NSDictionary *)head
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                          head:(NSDictionary *)head
                 JSONParameter:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                          head:(NSDictionary *)head
                    parameters:(NSDictionary *)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end


@protocol LXMNetworkSerialProtocol <NSObject>

- (id)lxmSerializationWithJSON:(id)JSON class:(Class)objcClass;

@end

@interface LXMNetworkDriver : NSObject

@property (nonatomic, weak) id<LXMNetworkDriverDelegate> delegate;

@property (nonatomic, weak) id<LXMNetworkSerialProtocol> serializer;

+ (LXMNetworkDriver *)shareInstance;

@end

NS_ASSUME_NONNULL_END
