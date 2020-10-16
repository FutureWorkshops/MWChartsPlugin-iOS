//
//  MobileWorkflowPieChartStep.swift
//  MobileWorkflowChartsPlugin
//
//  Created by Jonathan Flintham on 07/10/2020.
//

import Foundation
import MobileWorkflowCore
import ResearchKit

enum L10n {
    enum PieChart {
        static let descriptionLabel = "Quantities"
        static let legendLabel = "Types"
    }
}

public struct MobileWorkflowChartsPlugin: MobileWorkflowPlugin {
    public static var allStepsTypes: [MobileWorkflowStepType] {
        return MobileWorkflowChartStepType.allCases
    }
}

public enum MobileWorkflowChartStepType: String, MobileWorkflowStepType, CaseIterable {
    
    case pieChart = "chartsPieChart"
    
    public var typeName: String {
        return self.rawValue
    }
    
    public var stepClass: MobileWorkflowStep.Type {
        return MobileWorkflowPieChartStep.self
    }
}

struct PieChartItem {
    let label: String
    let value: Double
}

public class MobileWorkflowPieChartStep: ORKStep {
    
    let items: [PieChartItem]
    
    init(identifier: String, items: [PieChartItem]) {
        self.items = items
        super.init(identifier: identifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func stepViewControllerClass() -> AnyClass {
        return MobileWorkflowPieChartStepViewController.self
    }
}

extension MobileWorkflowPieChartStep: MobileWorkflowStep {
    
    public static func build(data: StepData, context: StepContext, networkManager: NetworkManager, imageLoader: ImageLoader, localizationManager: Localization) throws -> ORKStep {
        
        let itemContent = data.content["items"] as? [[String: Any]] ?? []
        let items: [PieChartItem] = try itemContent.map {
            guard let label = $0["label"] as? String else {
                throw ParseError.invalidStepData(cause: "Invalid label for pie chart data item")
            }
            guard let stringValue = $0["value"] as? String, let value = Double(stringValue) else {
                throw ParseError.invalidStepData(cause: "Invalid value for pie chart data item")
            }
            return PieChartItem(label: label, value: value)
        }
        
        return MobileWorkflowPieChartStep(identifier: data.identifier, items: items)
    }
}
