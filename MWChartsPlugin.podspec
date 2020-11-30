Pod::Spec.new do |s|
    s.name                  = 'MWChartsPlugin'
    s.version               = '0.0.11'
    s.summary               = 'Chart plugin for MobileWorkflow on iOS.'
    s.description           = <<-DESC
    Chart plugin for MobileWorkflow on iOS, based on Charts by Daniel Gindi: https://github.com/danielgindi/Charts
    DESC
    s.homepage              = 'https://www.mobileworkflow.io'
    s.license               = { :type => 'Copyright', :file => 'LICENSE' }
    s.author                = { 'Future Workshops' => 'info@futureworkshops.com' }
    s.source                = { :git => 'https://github.com/FutureWorkshops/MWChartsPlugin-iOS.git', :tag => "#{s.version}" }
    s.platform              = :ios
    s.swift_version         = '5'
    s.ios.deployment_target = '13.0'
	s.default_subspecs      = 'Core'
	
    s.subspec 'Core' do |cs|
	    cs.dependency            'MobileWorkflow'
	    cs.dependency            'Charts', '~> 3.6.0'
	    cs.dependency            'Colours', '~> 5.13.0'
        cs.source_files          = 'MobileWorkflowChartsPlugin/MWChartsPlugin/**/*.swift'
    end
end
