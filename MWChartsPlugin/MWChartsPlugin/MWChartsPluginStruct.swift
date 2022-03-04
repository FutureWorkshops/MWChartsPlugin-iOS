//
//  MWChartsPlugin.swift
//  MWChartsPlugin
//
//  Created by Jonathan Flintham on 12/02/2021.
//

import Foundation
import MobileWorkflowCore

enum L10n {
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
    
    case dashboard = "io.mobileworkflow.Dashboard" // legacy name
    case networkDashboard = "io.app-rail.charts.network-dashboard"
    
    public var typeName: String {
        return self.rawValue
    }
    
    public var stepClass: BuildableStep.Type {
        switch self {
        case .dashboard:
            return MWDashboardStep.self
        case .networkDashboard:
            return MWNetworkDashboardStep.self
        }
    }
}
