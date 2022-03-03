//
//  DashboardStepItem.swift
//  MWChartsPlugin
//
//  Created by Jonathan Flintham on 28/02/2022.
//

import Foundation
import MobileWorkflowCore

public struct DashboardStepItem: Codable {
    public enum ChartType: String, Codable {
        case none
        case pie
        case line
        case bar
    }
    
    let id: String
    let title: String
    let subtitle: String?
    let footer: String?
    let chartType: ChartType
    let values: [Double]
    
    public init(id: String, title: String, subtitle: String?, footer: String?, chartType: ChartType, values: [Double]) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.footer = footer
        self.chartType = chartType
        self.values = values
    }
}

extension DashboardStepItem: ValueProvider {
    public func fetchValue(for path: String) -> Any? {
        if path == CodingKeys.id.stringValue { return self.id }
        if path == CodingKeys.title.stringValue { return self.title }
        if path == CodingKeys.subtitle.stringValue { return self.subtitle }
        if path == CodingKeys.footer.stringValue { return self.footer }
        if path == CodingKeys.chartType.stringValue { return self.chartType }
        if path == CodingKeys.values.stringValue { return self.values }
        return nil
    }
    
    public func fetchProvider(for path: String) -> ValueProvider? {
        return nil
    }
}
