//
//  LXMBaseRequest.m
//  LXMNetwork
//
//  Created by luoxiaomiao on 2019/5/29.
//  Copyright © 2019 omiao. All rights reserved.
//

#import "LXMBaseRequest.h"
#import "LXMNetworkConstant.h"
#import "LXMNetworkDriver.h"

typedef void (^LXMNetworkSuccess)(NSURLSessionDataTask *task, id responseObject);

typedef void (^LXMNetworkFailure)(NSURLSessionDataTask *task, NSError *error);

NSString * const LXMNetworkOriginalResponseKey = @"LXMNetworkOriginalResponseKey";

@interface LXMBaseRequest()<LXMBaseRequestProtocol> {
    
    BOOL _mock;
    
    BOOL _retryCount;
    
    BOOL _serialize;
}

@property (nonatomic, assign) NSInteger maxRetryCount;

@property (nonatomic, strong) NSURLComponents *components;

@property (nonatomic, weak) NSURLSessionDataTask *task;

@property (nonatomic, copy) NSString *URLString;

@end

@implementation LXMBaseRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        _serialize = YES;
    }
    return self;
}

- (void)cancel {
    [_task cancel];
}

- (NSString *)URLString {
    if (!_URLString) {
        _URLString = [NSString stringWithFormat:@"%@://%@/%@", [self scheme], [self host], [self path]];
    }
    return _URLString;
}

- (__kindof LXMBaseRequest * _Nonnull (^)(LXMNetworkComplete _Nonnull))request {
    return ^(LXMNetworkComplete complete) {
        [self startRequest:complete method:[self method]];
        return self;
    };
}

- (__kindof LXMBaseRequest * _Nonnull (^)(BOOL))mock {
    return ^(BOOL mock) {
        self->_mock = mock;
        return self;
    };
}

- (__kindof LXMBaseRequest * _Nonnull (^)(NSInteger))retry {
    return ^(NSInteger retryCount) {
        self->_retryCount = retryCount;
        return self;
    };
}

- (__kindof LXMBaseRequest * _Nonnull (^)(NSDictionary * _Nonnull))addParams {
    return ^(NSDictionary *params) {
        self->_params = params;
        return self;
    };
}

- (__kindof LXMBaseRequest * _Nonnull (^)(BOOL))serialize {
    return ^(BOOL serialize) {
        self->_serialize = serialize;
        return self;
    };
}

- (void)startRequest:(LXMNetworkComplete)complete method:(LXMNetworkMethod)method {
    if (_task) {
        [_task cancel];
        _task = nil;
    }
    NSError *error;
    BOOL flag = [self prepareRequest:&error];
    if (!flag) {
        complete(NO, nil, error);
        return;
    }
    [self lxmHead];
    NSDictionary *param = [self lxmParams];
    LXMNetworkSuccess success = [self lxmSuccess:complete];
    if (_mock) {
        id data = [self lxmMockData:param];
        success(nil, data);
        return;
    }
    NSString *url = self.URLString;
    LXMNetworkFailure failure = [self lxmFailure:complete];
    switch (method) {
        case LXMNetworkMethodGET:
            _task = [[LXMNetworkDriver shareInstance].delegate GET:url head:[self lxmHead] parameters:param success:success failure:failure];
            break;
        case LXMNetworkMethodPOST:
            switch ([self parameterType]) {
                case LXMNetworkParameterTypeString:
                    _task = [[LXMNetworkDriver shareInstance].delegate POST:url head:[self lxmHead] parameters:param success:success failure:failure];
                    break;
                case LXMNetworkParameterTypeJSON:
                    _task = [[LXMNetworkDriver shareInstance].delegate POST:url head:[self lxmHead] parameters:param success:success failure:failure];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }    
}

- (NSDictionary *)head {
    return nil;
}

- (NSString *)host {
    return nil;
}

- (NSString *)path {
    return nil;
}

- (LXMNetworkMethod)method {
    return LXMNetworkMethodGET;
}

- (Class)responseClass {
    return [NSDictionary class];
}

- (NSArray<NSNumber *> *)retryInterval {
    return @[@1, @2, @4, @8, @32, @64];
}

- (NSString *)scheme {
    return [[LXMNetworkDriver shareInstance].delegate defaultSchmeForRequest:self];
}

- (NSInteger)retryCount {
    return 3;
}

- (LXMNetworkParameterType)parameterType {
    return LXMNetworkParameterTypeString;
}

- (NSUInteger)hash {
    return _components.string.hash;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    LXMBaseRequest *temp = object;
    return temp.hash == self.hash;
}

- (BOOL)correctResponse:(id)response {
    return YES;
}

- (id)validResponse:(id)originalResponse error:(NSError * _Nullable __autoreleasing *)error {
    if ([originalResponse isKindOfClass:[NSArray class]]) {
        return originalResponse;
    } else {
        if ([originalResponse isKindOfClass:[self responseClass]]) {
            return originalResponse;
        } else {
            NSDictionary *userInfo = @{LXMNetworkOriginalResponseKey : originalResponse ?: [NSNull null]};
            *error = [NSError errorWithDomain:@"response" code:LXMNetworkErrorResponse userInfo:userInfo];
            return nil;
        }
    }
}

- (id)lxmMockData:(NSDictionary *)param {
    id data;
    if ([self respondsToSelector:@selector(mockJSONData:)]) {
        data = [self mockJSONData:param];
    } else if ([self respondsToSelector:@selector(mockFilePath:)]) {
        NSString *filePath = [self mockFilePath:param];
        data = [[NSData alloc] initWithContentsOfFile:filePath];
    }
    return data;
}

- (NSDictionary *)lxmHead {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    LXMNetworkDriver *engine = [LXMNetworkDriver shareInstance];
    NSDictionary *defaultHeader = [engine.delegate defaultHeadForRequest:self];
    if (defaultHeader) {
        [dict setValuesForKeysWithDictionary:defaultHeader];
    }
    if ([self head]) {
        [dict setValuesForKeysWithDictionary:[self head]];
    }
    return dict.copy;
}

- (NSDictionary *)lxmParams {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSDictionary *params = [[LXMNetworkDriver shareInstance].delegate defaultParamsForRequest:self];
    if (params) {
        [dict setValuesForKeysWithDictionary:params];
    }
    params = [self params];
    if (params) {
        [dict setValuesForKeysWithDictionary:params];
    }
    return dict.copy;
}

- (LXMNetworkSuccess)lxmSuccess:(LXMNetworkComplete)complete {
    return ^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self respondsToSelector:@selector(customSerialization:error:)]) {
                NSError *error;
                id response = [self customSerialization:responseObject error:&error];
                complete(error == nil, response, error);
                return;
            }
            
            id json = [self JSONSerialization:responseObject];
            id response;
            if (self->_serialize) {
                response = [[LXMNetworkDriver shareInstance].serializer lxmSerializationWithJSON:json class:[self responseClass]];
            } else {
                response = json;
            }
            NSError *error;
            if (![self validResponse:response error:&error]) {
                if (!error) {
                    error = [NSError errorWithDomain:NSStringFromClass([self class]) code:LXMNetworkErrorResponse userInfo:@{LXMNetworkErrorInfoKey : response ?: @"error response"}];
                }
                complete(NO, response, error);
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(YES, response, nil);
            });
        });
    };
}

- (LXMNetworkFailure)lxmFailure:(LXMNetworkComplete)complete {
    return ^(NSURLSessionDataTask *task, NSError *error) {
        if (error.code != NSURLErrorCancelled && error.code != NSURLErrorUserCancelledAuthentication) {
            complete(NO, nil, error);
        }
    };
}

- (BOOL)prepareRequest:(NSError * _Nullable __autoreleasing *)error {
    NSURLComponents *components = [NSURLComponents new];
    components.scheme = [self scheme];
    components.host = [self host];
    components.path = [self path];
    NSMutableString *string = [NSMutableString string];
    NSDictionary *param = [self params];
    
    BOOL flag = [self combineParam:param query:string];
    if (!flag) {
        *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:LXMNetworkErrorParams userInfo:@{LXMNetworkErrorInfoKey : param}];
        return NO;
    }
    NSDictionary *defaultParam = [[LXMNetworkDriver shareInstance].delegate defaultParamsForRequest:self];
    flag = [self combineParam:defaultParam query:string];
    if (!flag) {
        *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:LXMNetworkErrorParams userInfo:@{LXMNetworkErrorInfoKey : defaultParam}];
        return NO;
    }
    components.query = string.copy;
    _components = components;
    return YES;
}

- (BOOL)combineParam:(NSDictionary *)param query:(NSMutableString *)query {
    __block BOOL flag = YES;
    [param enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (([obj isKindOfClass:[NSString class]] && ((NSString *)obj).length > 0) || [obj isKindOfClass:[NSNumber class]]) {
            if (query.length > 0) {
                [query appendString:@"&"];
            }
            [query appendFormat:@"%@=%@", key, obj];
        } else {
            flag = NO;
            *stop = YES;
        }
    }];
    return flag;
}

- (id)JSONSerialization:(id)responseObject {
    id result = nil;
    if ((responseObject && responseObject != (id)kCFNull)) {
        NSError *error = nil;
        if ([responseObject isKindOfClass:[NSString class]]) {
            responseObject = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        }
        if ([responseObject isKindOfClass:[NSData class]]) {
            result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        } else if([responseObject isKindOfClass:[NSDictionary class]] || [responseObject isKindOfClass:[NSArray class]]) {
            result = responseObject;
        }
    }
    return result;
}


@end
