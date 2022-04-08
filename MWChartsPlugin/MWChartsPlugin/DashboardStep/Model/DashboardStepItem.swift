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
        case statistic
        case pie
        case line
        case bar
    }
    
    let id: String
    let title: String
    let text: String?
    let footer: String?
    let chartType: ChartType
    let chartValues: [Double]?
    let chartColors: [String]?
    
    public init(id: String, title: String, text: String?, footer: String?, chartType: ChartType, chartValues: [Double]?, chartColors: [String]?) {
        self.id = id
        self.title = title
        self.text = text
        self.footer = footer
        self.chartType = chartType
        self.chartValues = chartValues
        self.chartColors = chartColors
    }
}

extension DashboardStepItem: ValueProvider {
    public func fetchValue(for path: String) -> Any? {
        if path == CodingKeys.id.stringValue { return self.id }
        if path == CodingKeys.title.stringValue { return self.title }
        if path == CodingKeys.text.stringValue { return self.text }
        if path == CodingKeys.footer.stringValue { return self.footer }
        if path == CodingKeys.chartType.stringValue { return self.chartType }
        if path == CodingKeys.chartValues.stringValue { return self.chartValues }
        if path == CodingKeys.chartColors.stringValue { return self.chartColors }
        return nil
    }
    
    public func fetchProvider(for path: String) -> ValueProvider? {
        return nil
    }
}
