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

public protocol PieChartStep: HasSecondaryWorkflows {
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
    public let secondaryWorkflowIDs: [String]
    public let items: [PieChartItem]
    
    init(identifier: String, stepContext: StepContext, secondaryWorkflowIDs: [String], items: [PieChartItem]) {
        self.stepContext = stepContext
        self.secondaryWorkflowIDs = secondaryWorkflowIDs
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

extension MWPieChartStep: BuildableStep {
    
    public static func build(stepInfo: StepInfo, services: StepServices) throws -> Step {
        
        let itemContent = stepInfo.data.content["items"] as? [[String: Any]] ?? []
        let items: [PieChartItem] = try itemContent.map {
            guard let label = $0["label"] as? String else {
                throw ParseError.invalidStepData(cause: "Invalid label for pie chart data item")
            }
            guard let stringValue = $0["value"] as? String, let value = Double(stringValue) else {
                throw ParseError.invalidStepData(cause: "Invalid value for pie chart data item")
            }
            return PieChartItem(label: label, value: value)
        }
        
        let secondaryWorkflowIDs: [String] = (stepInfo.data.content["workflows"] as? [[String: Any]])?.compactMap({ $0.getString(key: "id") }) ?? []
        
        return MWPieChartStep(identifier: stepInfo.data.identifier, stepContext: stepInfo.context, secondaryWorkflowIDs: secondaryWorkflowIDs, items: items)
    }
}
