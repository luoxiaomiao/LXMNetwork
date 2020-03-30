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

@protocol AFMultipartFormData;

typedef void(^LXMNetworkComplete) (BOOL success, id __nullable response, NSError *__nullable error);

typedef void(^LXMNetworkConstructingBody)(id<AFMultipartFormData> formData);

typedef void(^LXMNetworkProgress)(NSProgress *progress);

@interface LXMBaseRequest : NSObject

@property (nonatomic, copy, readonly) NSDictionary *params;

@property (nonatomic, copy, readonly) NSString *URLString;

@property (nonatomic, copy, readonly) __kindof LXMBaseRequest *(^mock)(BOOL flag);

@property (nonatomic, copy, readonly) __kindof LXMBaseRequest *(^addParams)(NSDictionary *params);

@property (nonatomic, copy, readonly) __kindof LXMBaseRequest *(^addConstructingBody)(LXMNetworkConstructingBody body);

@property (nonatomic, copy, readonly) __kindof LXMBaseRequest *(^addUploadProgress)(LXMNetworkProgress progress);

@property (nonatomic, copy, readonly) __kindof LXMBaseRequest *(^serialize)(BOOL autoSerialized);

@property (nonatomic, copy, readonly) __kindof LXMBaseRequest *(^request)(LXMNetworkComplete complete);

- (void)cancel;

#pragma mark - for override required;

- (NSString *)host;

- (NSString *)path;

- (LXMNetworkMethod)method;

- (Class)responseClass;

#pragma mark - for override optional;

- (LXMNetworkParameterType)parameterType;

- (BOOL)prepareRequest:(NSError **)error;

- (NSDictionary *)head;

- (NSString *)scheme;

- (id)validResponse:(id)originalResponse error:(NSError **)error;

@end


@protocol LXMRequestProtocol <NSObject>

@optional
- (id)customSerialization:(id)JSON error:(NSError **)error;

- (NSString *)mockFilePath:(NSDictionary *)param;

- (id)mockJSONData:(NSDictionary *)param;

@end

NS_ASSUME_NONNULL_END
