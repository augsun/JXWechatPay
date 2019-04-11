#
# Be sure to run `pod lib lint JXWechatPay.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JXWechatPay'
  s.version          = '1.0.7'
  s.summary          = 'A short description of JXWechatPay.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/augsun'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'CoderSun' => 'codersun@126.com' }
  s.source           = { :git => 'https://github.com/augsun/JXWechatPay.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'JXWechatPay/Classes/**/*.{h,m}'
  
  # s.resource_bundles = {
  #   'JXWechatPay' => ['JXWechatPay/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'SystemConfiguration', 'Security', 'CoreTelephony', 'CFNetwork'
  
   s.libraries = 'z', 'sqlite3.0', 'c++'
   
   s.dependency 'WechatOpenSDK', '1.8.4'
   
end
