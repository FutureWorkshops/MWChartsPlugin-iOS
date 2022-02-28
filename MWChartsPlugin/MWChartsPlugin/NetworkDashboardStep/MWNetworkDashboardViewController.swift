//
//  MWNetworkDashboardViewController.swift
//  MWChartsPlugin
//
//  Created by Jonathan Flintham on 28/02/2022.
//

import UIKit
import MobileWorkflowCore

public class MWNetworkDashboardStepViewController: MWDashboardStepViewController, RemoteContentStepViewController, ContentClearable {

    weak public var presentationDelegate: PresentationDelegate?
    
    public var remoteContentStep: MWNetworkDashboardStep! { self.mwStep as? MWNetworkDashboardStep }
    
    private lazy var stateView = {
        StateView(frame: .zero)
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.refreshControl = UIRefreshControl()
        self.collectionView.refreshControl?.addTarget(self, action: #selector(self.reloadContent), for: .valueChanged)
        
        self.stateView.translatesAutoresizingMaskIntoConstraints = true // needs to be true when used as tableView backgroundView
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resyncContent()
    }
    
    @objc func reloadContent() {
        self.loadContent()
    }
    
    public func clearContent() {
        self.update(content: [])
    }
    
    public func update(content: [DashboardItem]) {
        self.remoteContentStep.items = content
        self.refresh()
        
        if content.isEmpty {
            self.stateView.configure(subtitle: self.remoteContentStep.emptyText ?? L10n.Dashboard.defaultEmptyText, theme: self.step.theme)
            self.collectionView.backgroundView = self.stateView
        }
    }
    
    public func showLoading() {
        self.stateView.backgroundColor = self.collectionView.backgroundColor
        if self.collectionView.refreshControl?.isRefreshing == false, self.dashboardStep.items.isEmpty {
            self.stateView.configure(isLoading: true, theme: self.step.theme)
            self.collectionView.backgroundView = self.stateView
        }
        self.navigationFooterView.config.primaryButton.isEnabled = false
    }
    
    public func hideLoading() {
        self.collectionView.backgroundView = nil
        self.collectionView.refreshControl?.endRefreshing()
        self.navigationFooterView.config.primaryButton.isEnabled = true
    }
}
