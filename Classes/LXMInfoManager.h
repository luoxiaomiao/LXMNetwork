//
//  LXMInfoManager.h
//  LXMNetwork
//
//  Created by luoxiaomiao on 2019/5/30.
//  Copyright © 2019 omiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXMInfoManager : NSObject

+ (instancetype)shareInstance;

- (void)setupNetworkEngine;

@end

NS_ASSUME_NONNULL_END
