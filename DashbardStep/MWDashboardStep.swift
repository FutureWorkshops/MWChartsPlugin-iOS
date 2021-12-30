//
//  MWDashboardStep.swift
//  MWChartsPlugin
//
//  Created by Xavi Moll on 30/12/21.
//

import Foundation
import MobileWorkflowCore

struct DashboardItem: Codable {
    enum ChartType: String, Codable {
        case pie
        case line
        case bar
    }
    
    let title: String
    let subtitle: String?
    let chartType: ChartType?
    let footer: String?
}

class MWDashboardStep: MWStep {
    
    let items: [DashboardItem]
    
    init(identifier: String, items: [DashboardItem]) {
        self.items = items
        super.init(identifier: identifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func instantiateViewController() -> StepViewController {
        return MWDashboardStepViewController(step: self)
    }
}

extension MWDashboardStep: BuildableStep {
    static func build(stepInfo: StepInfo, services: StepServices) throws -> Step {
        let json = stepInfo.data.content
        guard let title = json["title"] as? String else {
            throw ParseError.invalidWorkflowData(cause: "Missing title for the dashboard item.")
        }
        
        let data = try JSONSerialization.data(withJSONObject: stepInfo.data.content, options: [])
        let items = try JSONDecoder().decode([DashboardItem].self, from: data)
        
        return MWDashboardStep(identifier: stepInfo.data.identifier, items: items)
    }
}
