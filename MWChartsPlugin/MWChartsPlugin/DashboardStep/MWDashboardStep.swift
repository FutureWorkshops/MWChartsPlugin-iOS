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
    public let numberOfColumns: Int
    public let items: [DashboardStepItem]
    
    init(identifier: String, stepContext: StepContext,  numberOfColumns: Int, items: [DashboardStepItem]) {
        self.stepContext = stepContext
        self.numberOfColumns = numberOfColumns
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
    
    public static var mandatoryCodingPaths: [CodingKey] {
        [["items": ["listItemId", "title", "chartType"]]]
    }
    
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
            var chartValues: [Double]?
            if let valuesString = $0["chartValues"] as? String {
                chartValues = valuesString.components(separatedBy: ",").compactMap {
                    $0.trimmingCharacters(in: .whitespacesAndNewlines).toDouble()
                }
            }
            var chartColors: [String]?
            if let valuesString = $0["chartColors"] as? String {
                chartColors = valuesString.components(separatedBy: ",").compactMap {
                    $0.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
            var chartColorsDark: [String]?
            if let valuesString = $0["chartColorsDark"] as? String {
                chartColorsDark = valuesString.components(separatedBy: ",").compactMap {
                    $0.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
            return DashboardStepItem(
                id: id,
                title: title,
                text: services.localizationService.translate($0["text"] as? String),
                footer: services.localizationService.translate($0["footer"] as? String),
                chartType: chartType,
                chartValues: chartValues,
                chartColors: chartColors,
                chartColorsDark: chartColorsDark
            )
        }
        
        let numberOfColumns = (stepInfo.data.content["numberOfColumns"] as? String)?.toInt() ?? 1 // default to 1 column
        
        return MWDashboardStep(identifier: stepInfo.data.identifier, stepContext: stepInfo.context, numberOfColumns: numberOfColumns, items: items)
    }
}

public struct ChartsDashboardItem: Codable {
    let chartType: String
    let listItemId: Float
    let title: String
    let chartColors: String?
    let chartColorsDark: String?
    let chartValues: String?
    let footer: String?
    let text: String?
    
    public static func chartsDashboardItem(
        chartType: String,
        listItemId: Float,
        title: String,
        chartColors: String? = nil,
        chartColorsDark: String? = nil,
        chartValues: String? = nil,
        footer: String? = nil,
        text: String? = nil
    ) -> ChartsDashboardItem {
        return ChartsDashboardItem(chartType: chartType, listItemId: listItemId, title: title, chartColors: chartColors, chartColorsDark: chartColorsDark, chartValues: chartValues, footer: footer, text: text)
    }
}

public class ChartsDashboardMetadata: StepMetadata {
    enum CodingKeys: String, CodingKey {
        case items
        case navigationItems = "_navigationItems"
        case numberOfColumns
    }
    
    let items: [ChartsDashboardItem]
    let navigationItems: [NavigationItemMetadata]?
    let numberOfColumns: String?
    
    init(id: String, title: String, items: [ChartsDashboardItem], navigationItems: [NavigationItemMetadata]?, numberOfColumns: String?, next: PushLinkMetadata?, links: [PushLinkMetadata]) {
        self.items = items
        self.navigationItems = navigationItems
        self.numberOfColumns = numberOfColumns
        super.init(id: id, type: "io.mobileworkflow.Dashboard", title: title, next: next, links: links)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try container.decode([ChartsDashboardItem].self, forKey: .items)
        self.navigationItems = try container.decodeIfPresent([NavigationItemMetadata].self, forKey: .navigationItems)
        self.numberOfColumns = try container.decodeIfPresent(String.self, forKey: .numberOfColumns)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.items, forKey: .items)
        try container.encodeIfPresent(self.navigationItems, forKey: .navigationItems)
        try container.encodeIfPresent(self.numberOfColumns, forKey: .numberOfColumns)
        try super.encode(to: encoder)
    }
}

public extension StepMetadata {
    static func chartsDashboard(
        id: String,
        title: String,
        items: [ChartsDashboardItem],
        navigationItems: [NavigationItemMetadata]? = nil,
        numberOfColumns: String? = nil,
        next: PushLinkMetadata? = nil,
        links: [PushLinkMetadata] = []
    ) -> ChartsDashboardMetadata {
        ChartsDashboardMetadata(id: id, title: title, items: items, navigationItems: navigationItems, numberOfColumns: numberOfColumns, next: next, links: links)
    }
}
