//
//  Model.h
//  Example
//
//  Created by luoxiaomiao on 2019/5/30.
//  Copyright © 2019 omiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject<YYModel>

@property (nonatomic, copy) NSString *origin;

@property (nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
