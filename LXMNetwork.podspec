
Pod::Spec.new do |s|
  s.name         = "LXMNetwork"
  s.version      = "0.0.1" 
  s.license      = "MIT" 
  s.summary      = "基于AFNetworking二次封装的网络组件" 

  s.homepage     = "https://github.com/luoxiaomiao/LXMNetwork" 
  s.source       = { :git => "https://github.com/luoxiaomiao/LXMNetwork.git", :tag => "#{s.version}" }
  s.source_files = "Classes/*.{h,m}" 
  s.requires_arc = true
  s.platform     = :ios, "7.0"
  s.dependency  "AFNetworking"
  s.dependency  "YYModel"
  s.frameworks = "UIKit", "Foundation"

  s.author             = { "LXM" => "834045350@qq.com" }
  s.social_media_url   = "https:www.omiao.cc"

end

