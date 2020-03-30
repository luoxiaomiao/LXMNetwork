
Pod::Spec.new do |spec|

  spec.name         = "LXMNetwork"
  spec.version      = "1.0.0"
  spec.summary      = "网络组件"
  spec.description  = <<-DESC
                      基于AFNetwoking的二次封装网络组件
                   DESC
  spec.homepage     = "https://github.com/luoxiaomiao/LXMNetwork"
  spec.license      = "MIT"
  spec.author             = { "luoxiaomiao" => "luoyangguang@live.com" }
  spec.platform     = :ios, "8.0"
  spec.source       = { :git => "https://github.com/luoxiaomiao/LXMNetwork.git", :tag => "#{spec.version}" }
  spec.source_files  = "Classes", "Classes/*.{h,m}"
  spec.requires_arc = true
  spec.dependency "AFNetworking/NSURLSession",'~>3.2.1'

end
