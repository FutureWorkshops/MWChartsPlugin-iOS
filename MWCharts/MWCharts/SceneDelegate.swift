//
//  SceneDelegate.swift
//  MobileWorkflowCharts
//
//  Created by Igor Ferreira on 11/05/2020.
//  Copyright © 2020 Future Workshops. All rights reserved.
//

import UIKit
import MobileWorkflowCore
import MWChartsPlugin

class SceneDelegate: MWSceneDelegate {
    
    override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        self.dependencies.plugins = [
            MWChartsPlugin.self
        ]
        
        super.scene(scene, willConnectTo: session, options: connectionOptions)
    }
}
