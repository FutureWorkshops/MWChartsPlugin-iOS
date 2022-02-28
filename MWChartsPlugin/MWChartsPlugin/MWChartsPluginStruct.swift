//
//  MWChartsPlugin.swift
//  MWChartsPlugin
//
//  Created by Jonathan Flintham on 12/02/2021.
//

import Foundation
import MobileWorkflowCore

enum L10n {
    enum PieChart {
        static let descriptionLabel = "Quantities"
        static let legendLabel = "Types"
        static let defaultEmptyText = "No data available"
    }
    
    enum Dashboard {
        static let defaultEmptyText = "No data available"
    }
}

public struct MWChartsPluginStruct: Plugin {
    public static var allStepsTypes: [StepType] {
        return MWChartstepType.allCases
    }
}

public enum MWChartstepType: String, StepType, CaseIterable {
    
    case pieChart = "chartsPieChart" // legacy naming convention
    case networkPieChart = "io.mobileworkflow.NetworkPieChart"
    case dashboard = "io.mobileworkflow.Dashboard"
    case networkDashboard = "io.app-rail.charts.network-dashboard"
    
    public var typeName: String {
        return self.rawValue
    }
    
    public var stepClass: BuildableStep.Type {
        switch self {
        case .pieChart:
            return MWPieChartStep.self
        case .networkPieChart:
            return MWNetworkPieChartStep.self
        case .dashboard:
            return MWDashboardStep.self
        case .networkDashboard:
            return MWNetworkDashboardStep.self
        }
    }
}
