# LXMNetwork

```ruby
pod 'LXMNetwork'
```

使用方法

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[LXMInfoManager shareInstance] setupNetworkEngine];

    return YES;
}
```
