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
    var numberOfColumns: Int { get }
    var items: [DashboardStepItem] { get }
}

public class MWDashboardStep: MWStep, DashboardStep {
    
    public let stepContext: StepContext
    public let numberOfColumns = 2 // TODO: add to static step config and parse
    public let items: [DashboardStepItem]
    
    init(identifier: String, stepContext: StepContext, items: [DashboardStepItem]) {
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
        let contentItems = stepInfo.data.content["items"] as? [[String: Any]] ?? []
        let items: [DashboardStepItem] = try contentItems.compactMap {
            guard let id = $0.getString(key: "listItemId") else {
                throw ParseError.invalidStepData(cause: "Dashboard item is missing required 'id' property")
            }
            guard let title = services.localizationService.translate($0["title"] as? String) else {
                throw ParseError.invalidStepData(cause: "Dashboard item is missing required 'title' property")
            }
            guard let chartTypeString = $0["chartType"] as? String else {
                throw ParseError.invalidStepData(cause: "Dashboard item is missing required 'chartType' property")
            }
            guard let chartType = DashboardStepItem.ChartType(rawValue: chartTypeString) else {
                throw ParseError.invalidStepData(cause: "Dashboard item has unsupported chartType: \(chartTypeString)")
            }
            var values: [Double]?
            if let valuesString = $0["values"] as? String {
                values = valuesString.components(separatedBy: ",").compactMap {
                    $0.trimmingCharacters(in: .whitespacesAndNewlines).toDouble()
                }
            }
            return DashboardStepItem(
                id: id,
                title: title,
                subtitle: services.localizationService.translate($0["subtitle"] as? String),
                footer: services.localizationService.translate($0["footer"] as? String),
                chartType: chartType,
                values: values ?? []
            )
        }
        
        return MWDashboardStep(identifier: stepInfo.data.identifier, stepContext: stepInfo.context, items: items)
    }
}
