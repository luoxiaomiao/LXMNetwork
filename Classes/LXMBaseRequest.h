//
//  LXMBaseRequest.h
//  LXMNetwork
//
//  Created by luoxiaomiao on 2019/5/29.
//  Copyright © 2019 omiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXMNetworkConstant.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LXMNetworkComplete) (BOOL success, id __nullable response, NSError *__nullable error);

@class LXMBaseRequest;

@interface LXMBaseRequest : NSObject

@property (nonatomic, copy, readonly) NSDictionary *params;

@property (nonatomic, copy, readonly) NSString *URLString;

@property (nonatomic, copy, readonly) __kindof LXMBaseRequest *(^mock)(BOOL flag);

@property (nonatomic, copy, readonly) __kindof LXMBaseRequest *(^retry)(NSInteger retryCount);

@property (nonatomic, copy, readonly) __kindof LXMBaseRequest *(^addParams)(NSDictionary *params);

@property (nonatomic, copy, readonly) __kindof LXMBaseRequest *(^serialize)(BOOL autoSerialized);

@property (nonatomic, copy, readonly) __kindof LXMBaseRequest *(^request)(LXMNetworkComplete complete);


- (void)cancel;


- (NSString *)host;

- (NSString *)path;

- (LXMNetworkMethod)method;

- (Class)responseClass;


- (LXMNetworkParameterType)parameterType;

- (BOOL)prepareRequest:(NSError **)error;

- (NSDictionary *)head;

- (NSString *)scheme;

- (NSArray<NSNumber *> *)retryInterval;

- (NSInteger)retryCount;

- (id)validResponse:(id)originalResponse error:(NSError **)error;

@end


@protocol LXMBaseRequestProtocol <NSObject>

@optional
- (id)customSerialization:(id)JSON error:(NSError **)error;

- (NSString *)mockFilePath:(NSDictionary *)param;

- (id)mockJSONData:(NSDictionary *)param;

@end

NS_ASSUME_NONNULL_END
