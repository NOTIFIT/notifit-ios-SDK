#
# Be sure to run `pod lib lint notifit-ios-sdk.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "notifit-ios-sdk"
  s.version          = "0.0.9"
  s.summary          = "iOS SDK for NOTIFIT"
  s.description      = <<-DESC
                       iOS SDK for our best idea - NOTIFIT
                       DESC
  s.homepage         = "https://github.com/NOTIFIT/notifit-ios-sdk"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Lukáš Hromadník" => "lukas.hromadnik@gmail.com", "Tomas Sykora" => "tomas.sykora@notifit.io" }
  s.source           = { :git => "https://github.com/NOTIFIT/notifit-ios-sdk.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/Syky27'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

   s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'notifit-ios-sdk' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end
