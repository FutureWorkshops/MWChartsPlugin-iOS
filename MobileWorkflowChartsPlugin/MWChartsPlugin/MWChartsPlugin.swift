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
    }
}

public struct MWChartsPlugin: MobileWorkflowPlugin {
    public static var allStepsTypes: [MobileWorkflowStepType] {
        return MWChartstepType.allCases
    }
}

public enum MWChartstepType: String, MobileWorkflowStepType, CaseIterable {
    
    case pieChart = "chartsPieChart" // legacy naming convention
    case networkPieChart = "io.mobileworkflow.NetworkPieChart"
    
    public var typeName: String {
        return self.rawValue
    }
    
    public var stepClass: MobileWorkflowStep.Type {
        switch self {
        case .pieChart:
            return MWPieChartStep.self
        case .networkPieChart:
            return MWNetworkPieChartStep.self
        }
    }
}
