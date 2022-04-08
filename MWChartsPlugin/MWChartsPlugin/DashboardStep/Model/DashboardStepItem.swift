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
    let chartColorsDark: [String]?
    
    public init(
        id: String,
        title: String,
        text: String?,
        footer: String?,
        chartType: ChartType,
        chartValues: [Double]?,
        chartColors: [String]?,
        chartColorsDark: [String]?
    ) {
        self.id = id
        self.title = title
        self.text = text
        self.footer = footer
        self.chartType = chartType
        self.chartValues = chartValues
        self.chartColors = chartColors
        self.chartColorsDark = chartColorsDark
    }
    
    var colors: [UIColor]? {
        guard let chartColors = self.chartColors?.compactMap({ UIColor(hex: $0) }),
              !chartColors.isEmpty else {
            return nil // dark colors ignored if no light ones provided
        }
        if let chartColorsDark = self.chartColorsDark?.compactMap({ UIColor(hex: $0) }),
           chartColorsDark.count == chartColors.count {
            return zip(chartColors, chartColorsDark).map { UIColor(light: $0, dark: $1) }
        } else {
            return chartColors // dark colors ignored unless same number of light ones provided
        }
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
        if path == CodingKeys.chartColorsDark.stringValue { return self.chartColorsDark }
        return nil
    }
    
    public func fetchProvider(for path: String) -> ValueProvider? {
        return nil
    }
}
