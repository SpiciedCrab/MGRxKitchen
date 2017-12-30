#
# Be sure to run `pod lib lint MGRxKitchen.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MGRxKitchen'
  s.version          = '4.0.15'
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
  s.dependency 'RxSwift' , '~>4.0.0'
  s.dependency 'RxCocoa' , '~>4.0.0'
  s.dependency 'NSObject+Rx'


  s.subspec 'RxMogoBaseConfiguration' do |base|
      base.source_files = 'MGRxKitchen/Classes/RxMogoBaseConfiguration/**/*{.swift}'
  end
  
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
      networking.dependency 'MGRxActivityIndicator'
  end

  s.subspec 'RxMogoForLoadingRefresher' do |loadingExtension|
      loadingExtension.source_files = 'MGRxKitchen/Classes/RxMogoForLoadingRefresher/**/*{.swift}'

  end

  s.subspec 'RxMogoBinding' do |bindingRx|
      bindingRx.source_files = 'MGRxKitchen/Classes/RxMogoBinding/**/*{.swift}'

  end

  s.subspec 'RxMogoForMJRefresher' do |mjExtension|
      mjExtension.source_files = 'MGRxKitchen/Classes/RxMogoForMJRefresher/**/*{.swift}'
      mjExtension.dependency 'MJRefresh'
      mjExtension.dependency 'MGRxKitchen/RxMogoBaseConfiguration'
  end

  s.subspec 'RxMogoForTableView' do |rxTable|
      rxTable.source_files = 'MGRxKitchen/Classes/RxMogoForTableView/**/*{.swift}'
      rxTable.dependency 'RxDataSources' 
  end

  s.subspec 'RxMogoForActionStage' do |actor|
      actor.source_files = 'MGRxKitchen/Classes/RxMogoForActionStage/**/*{.swift}'
      actor.dependency 'MGProgressHUD'
      actor.dependency 'MGRxActivityIndicator'
      actor.dependency 'MGActionStageSwift'
      actor.dependency 'MGRxKitchen/RxMogoForMGProgressErrors'
  end

  s.subspec 'RxMogoForMixer' do |mixer|
      mixer.source_files = 'MGRxKitchen/Classes/RxMogoIntergration/**/*{.swift}'
      mixer.dependency 'MGProgressHUD'
      mixer.dependency 'MGRxKitchen/RxMogoForTableView'
      mixer.dependency 'MGRxKitchen/RxMogoForNetworkingProcessing'
      mixer.dependency 'MGRxKitchen/RxMogoForMGProgressErrors'
      mixer.dependency 'MGRxKitchen/RxMogoForMJRefresher'
      mixer.dependency 'MGRxKitchen/RxMogoBaseConfiguration'
  end

  s.subspec 'RxMogoForSuperAlert' do |alertMixer|
      alertMixer.source_files = 'MGRxKitchen/Classes/RxMogoForSuperAlert/**/*{.swift}'
      alertMixer.dependency 'MGUIKit/MGAlertView'
      alertMixer.dependency 'MGRxKitchen/RxMogoForMixer'
  end
  
  # s.resource_bundles = {
  #   'MGRxKitchen' => ['MGRxKitchen/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
