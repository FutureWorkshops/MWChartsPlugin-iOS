source 'https://cdn.cocoapods.org/'
source 'https://github.com/FutureWorkshops/FWTPodspecs.git'

workspace 'MobileWorkflowCharts'
platform :ios, '13.0'

inhibit_all_warnings!
use_frameworks!

project 'MobileWorkflowCharts/MobileWorkflowCharts.xcodeproj'
project 'MobileWorkflowChartsPlugin/MobileWorkflowChartsPlugin.xcodeproj'

abstract_target 'MWCharts' do
  pod 'MobileWorkflow', :git => 'https://github.com/FutureWorkshops/MobileWorkflowCore-iOS-Distribution.git', :branch => 'bug/cocoapods_version'
  pod 'Charts'

  target 'MobileWorkflowCharts' do
    project 'MobileWorkflowCharts/MobileWorkflowCharts.xcodeproj'

    target 'MobileWorkflowChartsTests' do
      inherit! :search_paths
    end
  end

  target 'MobileWorkflowChartsPlugin' do
    project 'MobileWorkflowChartsPlugin/MobileWorkflowChartsPlugin.xcodeproj'

    target 'MobileWorkflowChartsPluginTests' do
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
