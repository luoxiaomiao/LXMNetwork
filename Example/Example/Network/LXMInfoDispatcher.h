//
//  LXMInfoDispatcher.h
//  Example
//
//  Created by luoxiaomiao on 2019/8/6.
//  Copyright © 2019 omiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXMInfoDispatcher : NSObject

+ (instancetype)shareInstance;

- (void)setupNetworkDriver;

@end

NS_ASSUME_NONNULL_END
