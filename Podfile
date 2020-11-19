source 'https://cdn.cocoapods.org/'
source 'https://github.com/FutureWorkshops/FWTPodspecs.git'

workspace 'MobileWorkflowCharts'
platform :ios, '13.0'

inhibit_all_warnings!
use_frameworks!

project 'MobileWorkflowCharts/MobileWorkflowCharts.xcodeproj'
project 'MWChartsPlugin/MWChartsPlugin.xcodeproj'

abstract_target 'MWCharts' do
  pod 'MobileWorkflow'
  pod 'Charts'
  pod 'Colours'

  target 'MobileWorkflowCharts' do
    project 'MobileWorkflowCharts/MobileWorkflowCharts.xcodeproj'

    target 'MobileWorkflowChartsTests' do
      inherit! :search_paths
    end
  end

  target 'MWChartsPlugin' do
    project 'MobileWorkflowChartsPlugin/MWChartsPlugin.xcodeproj'

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
