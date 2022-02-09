//
//  MWPieChartStep.swift
//  MWChartsPlugin
//
//  Created by Jonathan Flintham on 07/10/2020.
//

import Foundation
import MobileWorkflowCore

public struct PieChartItem: Codable {
    let label: String
    let value: Double
    
    public init(label: String, value: Double) {
        self.label = label
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Self.CodingKeys.self)
        self.label = try container.decode(String.self, forKey: .label)
        let stringValue = try container.decode(String.self, forKey: .value)
        guard let value = Double(stringValue) else {
            throw ParseError.invalidStepData(cause: "Invalid value for pie chart data item")
        }
        self.value = value
    }
}

public protocol PieChartStep {
    var stepContext: StepContext { get }
    var items: [PieChartItem] { get }
}

public struct NetworkPieChartItemTask: CredentializedAsyncTask, URLAsyncTaskConvertible {
    public typealias Response = [PieChartItem]
    public let input: URL
    public let credential: Credential?
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
            guard let value = extractValue(from: $0["value"]) else {
                throw ParseError.invalidStepData(cause: "Invalid value for pie chart data item")
            }
            return PieChartItem(label: label, value: value)
        }

        return MWPieChartStep(identifier: stepInfo.data.identifier, stepContext: stepInfo.context, items: items)
    }
}
