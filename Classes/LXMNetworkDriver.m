//
//  LXMNetworkDriver.m
//  LXMNetwork
//
//  Created by luoxiaomiao on 2019/5/29.
//  Copyright © 2019 omiao. All rights reserved.
//

#import "LXMNetworkDriver.h"

@implementation LXMNetworkDriver

+ (LXMNetworkDriver *)shareInstance {
    static LXMNetworkDriver *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

@end
