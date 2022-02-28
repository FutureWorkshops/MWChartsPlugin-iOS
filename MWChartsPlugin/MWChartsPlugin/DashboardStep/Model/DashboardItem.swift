//
//  DashboardItem.swift
//  MWChartsPlugin
//
//  Created by Jonathan Flintham on 28/02/2022.
//

import Foundation

public struct DashboardItem: Codable {
    enum ChartType: String, Codable {
        case none
        case pie
        case line
        case bar
    }
    
    let title: String
    let subtitle: String?
    let footer: String?
    let chartType: ChartType
    let values: [Double]?
}
