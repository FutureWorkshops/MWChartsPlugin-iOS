source 'https://cdn.cocoapods.org/'
source 'https://github.com/FutureWorkshops/MWPodspecs.git'

workspace 'MWCharts'
platform :ios, '17.1'

inhibit_all_warnings!
use_frameworks!

project 'MWCharts/MWCharts.xcodeproj'
project 'MWChartsPlugin/MWChartsPlugin.xcodeproj'

abstract_target 'MWCharts' do
  pod 'MobileWorkflow'
  pod 'Charts'
  pod 'Colours'

  target 'MWCharts' do
    project 'MWCharts/MWCharts.xcodeproj'
    pod 'MWChartsPlugin', path: './MWChartsPlugin.podspec'
    
    target 'MWChartsTests' do
      inherit! :search_paths
    end
  end

  target 'MWChartsPlugin' do
    project 'MWChartsPlugin/MWChartsPlugin.xcodeproj'

    target 'MWChartsPluginTests' do
      inherit! :search_paths
    end
  end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = ""
    end
  end
end
