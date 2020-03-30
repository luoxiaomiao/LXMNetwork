//
//  CustomRequest.m
//  Example
//
//  Created by luoxiaomiao on 2019/5/30.
//  Copyright © 2019 omiao. All rights reserved.
//

#import "CustomRequest.h"
#import "Model.h"

@implementation CustomRequest

- (NSString *)host {
    return @"httpbin.org";
}

- (NSString *)path {
    return @"post";
}

- (Class)responseClass {
    return [Model class];
}
@end
