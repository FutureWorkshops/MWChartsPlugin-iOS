//
//  MWDashboardStepViewController.swift
//  MWChartsPlugin
//
//  Created by Xavi Moll on 30/12/21.
//

import UIKit
import Foundation
import MobileWorkflowCore

class MWDashboardStepViewController: MWStepViewController {
    
    var dashboardStep: MWDashboardStep { self.mwStep as! MWDashboardStep }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        print(self.dashboardStep)
    }
}
