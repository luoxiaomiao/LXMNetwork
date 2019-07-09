# LXMNetwork

## 项目介绍
本项目基于AFNetworking和YYModel设计，轻量简洁，功能全面，可实现出参Model化，错误异常捕获，Mock本地JSON。

## 集成方式

```ruby
pod 'LXMNetwork'
```

## 使用方法

首先AppDelegate启动项目组件，然后新建基于LXMRequest基类的子类，重写host、path、method、responseClass等方法即可。

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[LXMInfoManager shareInstance] setupNetworkEngine];

    return YES;
}
```
