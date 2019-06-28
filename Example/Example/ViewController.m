//
//  ViewController.m
//  Example
//
//  Created by luoxiaomiao on 2019/5/30.
//  Copyright © 2019 omiao. All rights reserved.
//

#import "ViewController.h"
#import "CustomRequest.h"
#import "Model.h"

@interface ViewController ()

@property (nonatomic, strong) CustomRequest *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _manager = [[CustomRequest alloc] init];
    _manager.request(^(BOOL success, id  _Nullable response, NSError * _Nullable error) {
        if (success) {
            Model *model = (Model *)response;
            NSLog(@"%@", model.origin);
            NSLog(@"%@", model.url);
        }
    });
}


@end
