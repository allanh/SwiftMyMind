# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end

target 'MyMind' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MyMind
    pod 'RxSwift', '6.1.0'
    pod 'RxCocoa', '6.1.0'
    pod 'NVActivityIndicatorView'
    pod 'LookinServer', :configurations => ['Debug']
    pod 'Charts'
    pod 'PromiseKit', '~> 6.8'
    pod 'Kingfisher', '~> 6.0'
    pod 'SwiftOTP'

  target 'MyMindTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking'
  end

  target 'MyMindUITests' do
    # Pods for testing
  end

end
