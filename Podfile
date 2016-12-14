platform :ios, '10.0'

target 'CallEx' do
  use_frameworks!
  pod 'RealmSwift'
end

target 'zw_intercept' do
  use_frameworks!
  pod 'RealmSwift'
end

target 'zw' do
  use_frameworks!
  pod 'SnapKit', '~> 3.0.2'
  pod 'Alamofire', '~> 4.2.0'
  #pod 'MJRefresh'
  pod 'SwiftyJSON'
  pod 'MGSwipeTableCell'
  pod 'RealmSwift'
  pod 'SVProgressHUD', :git => 'https://github.com/SVProgressHUD/SVProgressHUD.git'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0.2'
    end
  end
end
