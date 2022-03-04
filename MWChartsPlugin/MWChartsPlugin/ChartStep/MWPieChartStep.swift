//
//  MWPieChartStep.swift
//  MWChartsPlugin
//
//  Created by Jonathan Flintham on 07/10/2020.
//

import Foundation
import MobileWorkflowCore

public protocol PieChartStep {
    var stepContext: StepContext { get }
    var items: [PieChartItem] { get }
}

public class MWPieChartStep: MWStep, PieChartStep {
    
    public let stepContext: StepContext
    public let items: [PieChartItem]
    
    init(identifier: String, stepContext: StepContext, items: [PieChartItem]) {
        self.stepContext = stepContext
        self.items = items
        super.init(identifier: identifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func instantiateViewController() -> StepViewController {
        MWPieChartStepViewController(step: self)
    }
}

extension String {
    func toDouble() -> Double? {
        return Double(self)
    }
}

extension MWPieChartStep: BuildableStep {
    
    
    /// This method helps with supporting against changes in the Json of type between string and double
    /// - Parameter rawValue: Value as it comes in the Json file
    /// - Returns: Value decoded as Double (if present)
    private static func extractValue(from rawValue: Any) -> Double? {
        if let value = rawValue as? Double {
            return value
        }
        
        if let value = (rawValue as? String)?.toDouble() {
            return value
        }
        
        if let value = (rawValue as? NSNumber)?.doubleValue {
            return value
        }
        
        return nil
    }
    
    public static func build(stepInfo: StepInfo, services: StepServices) throws -> Step {
        
        let itemContent = stepInfo.data.content["items"] as? [[String: Any]] ?? []
        let items: [PieChartItem] = try itemContent.map {
            guard let label = $0["label"] as? String else {
                throw ParseError.invalidStepData(cause: "Invalid label for pie chart data item")
            }
            guard let value = extractValue(from: $0["value"] as Any) else {
                throw ParseError.invalidStepData(cause: "Invalid value for pie chart data item")
            }
            return PieChartItem(label: label, value: value)
        }

        return MWPieChartStep(identifier: stepInfo.data.identifier, stepContext: stepInfo.context, items: items)
    }
}
