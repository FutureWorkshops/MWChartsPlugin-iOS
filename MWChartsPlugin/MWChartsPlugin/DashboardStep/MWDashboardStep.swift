//
//  MWDashboardStep.swift
//  MWChartsPlugin
//
//  Created by Xavi Moll on 30/12/21.
//

import Foundation
import MobileWorkflowCore

public protocol DashboardStep {
    var stepContext: StepContext { get }
    var items: [DashboardItem] { get }
}

public class MWDashboardStep: MWStep, DashboardStep {
    
    public let stepContext: StepContext
    public let items: [DashboardItem]
    
    init(identifier: String, stepContext: StepContext, items: [DashboardItem]) {
        self.stepContext = stepContext
        self.items = items
        super.init(identifier: identifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func instantiateViewController() -> StepViewController {
        return MWDashboardStepViewController(step: self)
    }
}

extension MWDashboardStep: BuildableStep {
    public static func build(stepInfo: StepInfo, services: StepServices) throws -> Step {
        let json = stepInfo.data.content
        guard let title = json["title"] as? String else {
            throw ParseError.invalidStepData(cause: "Missing title for the dashboard item.")
        }
        let rawItems = json["items"] as? Array<[String: Any]> ?? []
        let data = try JSONSerialization.data(withJSONObject: rawItems, options: [])
        let items = try JSONDecoder().decode([DashboardItem].self, from: data)
        
        return MWDashboardStep(identifier: stepInfo.data.identifier, stepContext: stepInfo.context, items: items)
    }
}
