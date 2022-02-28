//
//  PieChartItem.swift
//  MWChartsPlugin
//
//  Created by Jonathan Flintham on 28/02/2022.
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
