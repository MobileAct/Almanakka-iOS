#
# Be sure to run `pod lib lint Almanakka.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Almanakka'
  s.version          = '0.0.1'
  s.summary          = 'A calendar library that simplifies calendar related operations. It also includes a customizable calendar picker.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
An iOS calendar library that can be used to simplify commonly performed operations when dealing with calendars without having to worry about handling NSDate yourself.
A calendar picker is also provided that can be use as is or customized to fit your apps theme. A UIView that displays a calendar can also be used in case you need to embed it on an already existing view controller.
                       DESC

  s.homepage         = 'https://github.com/MobileAct/Almanakka-iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = { 'Oscar Peredo' => 'luisoscar@gmail.com', 'Binish Peter' => 'legendbinish124@gmail.com' }
  s.source           = { :git => 'https://github.com/MobileAct/Almanakka-iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.swift_version = '5.0'

  s.ios.deployment_target = '12.4'

  s.info_plist = { 'CFBundleIdentifier' => 'com.mobile-act.Almanakka' }

  s.pod_target_xcconfig = { 'PRODUCT_BUNDLE_IDENTIFIER': 'com.mobile-act.Almanakka' }


  s.source_files = 'Almanakka/Classes/**/*.{swift}'


#  s.resource_bundles = {
#    'Almanakka' => ['Almanakka/Classes/**/*.{storyboard,xib,lproj,png}',
#                    'Almanakka/Assets/*']
#  }

  # Might wanna separate the CSV into a different bundle.
  s.resource_bundles = {
    'Almanakka' => ['Almanakka/Assets/**/*.{storyboard,xib,lproj,png,csv}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
