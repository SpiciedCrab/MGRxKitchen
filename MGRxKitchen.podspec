#
# Be sure to run `pod lib lint MGRxKitchen.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MGRxKitchen'
  s.version          = '1.3.4'
  s.summary          = 'Rx plugins for Mogo'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/SpiciedCrab/MGRxKitchen'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'magic_harly@hotmail.com' => 'magic_harly@hotmail.com' }
  s.source           = { :git => 'https://github.com/SpiciedCrab/MGRxKitchen.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.resources = 'MGRxKitchen/Assets/*.png'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'


  s.subspec 'RxMogoForMGProgressErrors' do |mgProgress|
      mgProgress.source_files = 'MGRxKitchen/Classes/RxMogoForMGProgressErrors/**/*{.swift}'
      mgProgress.dependency 'MGProgressHUD'
      mgProgress.dependency 'MGBricks'
      mgProgress.dependency 'MGRxKitchen/RxMogoForNetworkingProcessing'
  end

  s.subspec 'RxMogoForNetworkingProcessing' do |networking|
      networking.source_files = 'MGRxKitchen/Classes/RxMogoForNetworkingProcessing/**/*{.swift}'
      networking.dependency 'Result'
      networking.dependency 'MGBricks'
      networking.dependency 'HandyJSON'
      networking.dependency 'RxSwiftUtilities'
  end

  s.subspec 'RxMogoForLoadingRefresher' do |loadingExtension|
      loadingExtension.source_files = 'MGRxKitchen/Classes/RxMogoForLoadingRefresher/**/*{.swift}'

  end

  s.subspec 'RxMogoForMJRefresher' do |mjExtension|
      mjExtension.source_files = 'MGRxKitchen/Classes/RxMogoForMJRefresher/**/*{.swift}'
      mjExtension.dependency 'MJRefresh'
  end

  s.subspec 'RxMogoForTableView' do |rxTable|
      rxTable.source_files = 'MGRxKitchen/Classes/RxMogoForTableView/**/*{.swift}'
      rxTable.dependency 'RxDataSources'
  end
  
  # s.resource_bundles = {
  #   'MGRxKitchen' => ['MGRxKitchen/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
