//
//  MobileWorkflowChartStep.swift
//  MobileWorkflowChartsPlugin
//
//  Created by Jonathan Flintham on 07/10/2020.
//

import Foundation
import MobileWorkflowCore
import ResearchKit

public class MobileWorkflowChartStep: ORKStep, BuildableStep {
    public static var stepClassName: String {
        return String(describing: self)
    }
    
    public static func build(data: StepData, networkManager: NetworkManager, imageLoader: ImageLoader, localizationManager: Localization) throws -> ORKStep {
        return MobileWorkflowChartStep(identifier: data.identifier)
    }
    
    public override func stepViewControllerClass() -> AnyClass {
        return MobileWorkflowChartStepViewController.self
    }
}
