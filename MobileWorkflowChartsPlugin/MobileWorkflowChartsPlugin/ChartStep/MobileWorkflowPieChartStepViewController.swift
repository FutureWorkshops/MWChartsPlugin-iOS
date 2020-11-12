//
//  MobileWorkflowChartViewController.swift
//  MobileWorkflowChartsPlugin
//
//  Created by Jonathan Flintham on 07/10/2020.
//

import Foundation
import MobileWorkflowCore
import Charts

public class MobileWorkflowPieChartStepViewController: ORKStepViewController {
    
    private var pieChartView: PieChartView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationFooterView()
        self.setupPieChartView()
        self.setupConstraints()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // need to wait to perform these actions so that ResearchKit can do its own configuration
        self.navigationFooterView?.continueButtonItem = self.continueButtonItem
        self.navigationFooterView?.continueEnabled = true
        
        let items = (self.step as? MobileWorkflowPieChartStep)?.items ?? []
        self.updatePieChart(items: items)
    }
    
    // MARK: Configuration
    
    private func setupNavigationFooterView() {
        guard self.navigationFooterView == nil else { return }
        
        let navigationFooterView = ORKNavigationContainerView()
        navigationFooterView.translatesAutoresizingMaskIntoConstraints = false
        self.navigationFooterView = navigationFooterView
        self.view.addSubview(navigationFooterView)
    }
    
    private func setupPieChartView() {
        self.pieChartView = PieChartView()
        self.pieChartView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.pieChartView)
    }
    
    private func setupConstraints() {
        guard let pieChartView = self.pieChartView, let navigationFooterView = self.navigationFooterView else { return }
        
        let constraints = [
            pieChartView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            pieChartView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            pieChartView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            pieChartView.bottomAnchor.constraint(equalTo: navigationFooterView.topAnchor),
            navigationFooterView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            navigationFooterView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            navigationFooterView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func updatePieChart(items: [PieChartItem]) {
        let entries = items.map {
            PieChartDataEntry(value: $0.value, label: $0.label)
        }
        let dataSet = PieChartDataSet(entries: entries, label: nil)
        let data = PieChartData(dataSets: [dataSet])
        self.pieChartView.data = data
        self.pieChartView.chartDescription?.text = nil
        
        // Colors
        dataSet.colors = ChartColorTemplates.joyful()
        dataSet.valueColors = [.black]
        dataSet.entryLabelColor = .black
        self.pieChartView.drawHoleEnabled = false
        self.pieChartView.legend.enabled = false
        self.pieChartView.rotationEnabled = false
        
        self.pieChartView.notifyDataSetChanged()
    }
}
