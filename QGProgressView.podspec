#
# Be sure to run `pod lib lint QGProgressView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QGProgressView'
  s.version          = '0.2.0'
  s.summary          = 'A short description of QGProgressView.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A circular progress view, simple but good.
                       DESC

  s.homepage         = 'https://github.com/Quanhua-Guan/QGProgressView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Quanhua-Guan' => 'xinmuheart@163.com' }
  s.source           = { :git => 'https://github.com/Quanhua-Guan/QGProgressView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'QGProgressView/Classes/**/*'
  
  s.resource_bundles = {
    'QGProgressView' => ['QGProgressView/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'QuartzCore'
end
