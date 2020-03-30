//
//  LXMNetworkConstant.h
//  LXMNetwork
//
//  Created by luoxiaomiao on 2019/5/29.
//  Copyright © 2019 omiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LXMNetworkMethod) {
    LXMNetworkMethodGET,
    LXMNetworkMethodPOST,
    LXMNetworkMethodDownload
};

typedef NS_ENUM(NSUInteger, LXMNetworkError) {
    LXMNetworkErrorParams,
    LXMNetworkErrorResponse,
    LXMNetworkErrorInvalidResponse
};

typedef NS_ENUM(NSUInteger, LXMNetworkParameterType) {
    LXMNetworkParameterTypeString,
    LXMNetworkParameterTypeJSON,
    LXMNetworkParameterTypeFormData
};

FOUNDATION_EXTERN NSString * const LXMNetworkErrorInfoKey;

FOUNDATION_EXTERN NSString * const LXMRequestHTTP;

FOUNDATION_EXTERN NSString * const LXMRequestHTTPS;

NS_ASSUME_NONNULL_END
