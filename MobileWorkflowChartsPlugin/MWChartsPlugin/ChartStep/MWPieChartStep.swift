//
//  MobileWorkflowPieChartStep.swift
//  MWChartsPlugin
//
//  Created by Jonathan Flintham on 07/10/2020.
//

import Foundation
import MobileWorkflowCore

struct PieChartItem {
    let label: String
    let value: Double
}

protocol PieChartStep {
    
}

public class MWPieChartStep: ORKStep {
    
    let items: [PieChartItem]
    let systemTintColor: UIColor
    
    init(identifier: String, items: [PieChartItem], systemTintColor: UIColor) {
        self.items = items
        self.systemTintColor = systemTintColor
        super.init(identifier: identifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func stepViewControllerClass() -> AnyClass {
        return MWPieChartStepViewController.self
    }
}

extension MWPieChartStep: MobileWorkflowStep {
    
    public static func build(step: StepInfo, services: MobileWorkflowServices) throws -> ORKStep {
        
        let itemContent = step.data.content["items"] as? [[String: Any]] ?? []
        let items: [PieChartItem] = try itemContent.map {
            guard let label = $0["label"] as? String else {
                throw ParseError.invalidStepData(cause: "Invalid label for pie chart data item")
            }
            guard let stringValue = $0["value"] as? String, let value = Double(stringValue) else {
                throw ParseError.invalidStepData(cause: "Invalid value for pie chart data item")
            }
            return PieChartItem(label: label, value: value)
        }
        
        return MWPieChartStep(identifier: step.data.identifier, items: items, systemTintColor: step.context.systemTintColor)
    }
}
