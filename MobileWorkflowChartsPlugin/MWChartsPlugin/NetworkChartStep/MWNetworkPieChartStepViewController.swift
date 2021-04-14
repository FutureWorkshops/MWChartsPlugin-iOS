//
//  MWNetworkPieChartStepViewController.swift
//  MWChartsPlugin
//
//  Created by Jonathan Flintham on 12/02/2021.
//

import Foundation
import MobileWorkflowCore

public class MWNetworkPieChartStepViewController: MWPieChartStepViewController, RemoteContentStepViewController, ContentClearable {

    weak public var workflowPresentationDelegate: WorkflowPresentationDelegate?
    
    public var remoteContentStep: MWNetworkPieChartStep! { self.mwStep as? MWNetworkPieChartStep }
    
    private lazy var stateView = {
        StateView(frame: .zero)
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupStateView()
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
    
    public func update(content: [PieChartItem]) {
        self.remoteContentStep.items = content
        self.refresh()
        if content.isEmpty {
            self.stateView.configure(subtitle: self.remoteContentStep.emptyText ?? L10n.PieChart.defaultEmptyText)
            self.stateView.isHidden = false
        }
    }
    
    private func setupStateView() {
        self.stateView.backgroundColor = self.view.backgroundColor
        self.stateView.translatesAutoresizingMaskIntoConstraints = false
        self.pieChartView.addSubview(self.stateView)
        NSLayoutConstraint.activate([
            self.stateView.topAnchor.constraint(equalTo: self.pieChartView.topAnchor),
            self.stateView.leadingAnchor.constraint(equalTo: self.pieChartView.leadingAnchor),
            self.stateView.trailingAnchor.constraint(equalTo: self.pieChartView.trailingAnchor),
            self.stateView.bottomAnchor.constraint(equalTo: self.pieChartView.bottomAnchor)
        ])
    }
    
    public func showLoading() {
        if self.remoteContentStep.items.isEmpty {
            self.stateView.configure(isLoading: true)
            self.stateView.isHidden = false
        }
        self.navigationFooterView.config.primaryButton.isEnabled = false
    }
    
    public func hideLoading() {
        self.stateView.configure(isLoading: false)
        self.stateView.isHidden = true
        self.navigationFooterView.config.primaryButton.isEnabled = true
    }
}
