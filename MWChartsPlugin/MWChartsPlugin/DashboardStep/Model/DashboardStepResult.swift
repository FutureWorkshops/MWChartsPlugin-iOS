//
//  DashboardStepResult.swift
//  MWChartsPlugin
//
//  Created by Jonathan Flintham on 03/03/2022.
//

import Foundation
import MobileWorkflowCore

extension DashboardStepItem: SelectionItem {
    public var resultKey: String? {
        return self.id
    }
}

class DashboardStepResult: SelectionResult<DashboardStepItem> { }
