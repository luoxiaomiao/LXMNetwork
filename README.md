# LXMNetwork

## 项目介绍
本项目基于AFNetworking设计，可以配合YYModel和MJExtension使用，轻量简洁，功能全面，可实现出参Model化，错误异常捕获，Mock本地JSON。

**注意：retry相关方法会在之后的版本中实现**

## 集成方式

```ruby
pod 'LXMNetwork'~>1.0.0
```

## 使用方法
新建一下LXMInfoHolder工具类遵循LXMNetworkDriverDelegate、LXMNetworkSerialProtocol实现这两个协议的方法，然后新建一个AFHTTPSessionManager的子类，非必要，配置相关参数，具体可以参考Example。

最后AppDelegate启动项目组件，新建基于LXMRequest基类的子类，重写host、path、method、responseClass等方法即可。

```Objective-C
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[LXMInfoHolder shareInstance] setupNetworkDriver];

    return YES;
}
```
### response返回Model
实现```responseClass```方法
```
- (Class)responseClass {
    return [Model class];
}
```
### 返回JSON
#### 设置serialize参数
```
serialize(NO)
```
#### 实现协议方法
```
- (id)customSerialization:(id)JSON error:(NSError **)error {
    return JSON;
}
```


