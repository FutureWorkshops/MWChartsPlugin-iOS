//
//  MobileWorkflowChartViewController.swift
//  MWChartsPlugin
//
//  Created by Jonathan Flintham on 07/10/2020.
//

import Foundation
import MobileWorkflowCore
import Charts
import Colours

public class MWPieChartStepViewController: MWContentStepViewController, HasSecondaryWorkflows {
    
    public var pieChartStep: PieChartStep {
        return self.mwStep as! PieChartStep
    }
    
    private var titleLabel: StepTitleLabel!
    private(set) var pieChartView: PieChartView!
    
    public var secondaryWorkflowIDs: [String] {
        return self.pieChartStep.secondaryWorkflowIDs
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTitle()
        self.setupPieChartView()
        self.setupConstraints()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refresh()
    }
    
    // MARK: Configuration
    
    private func setupTitle() {
        self.titleLabel = StepTitleLabel()
        self.titleLabel.numberOfLines = 0
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.titleLabel)
    }
    
    private func setupPieChartView() {
        self.pieChartView = PieChartView()
        self.pieChartView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.pieChartView)
    }
    
    private func setupConstraints() {
        guard let titleLabel = self.titleLabel, let pieChartView = self.pieChartView else { return }
        
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leftAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.rightAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 45),
            pieChartView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            pieChartView.leftAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leftAnchor),
            pieChartView.rightAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.rightAnchor),
            pieChartView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    public func refresh() {
        guard let pieChartStep = self.mwStep as? PieChartStep else { return }
        self.titleLabel.text = self.mwStep.title
        self.updatePieChart(items: pieChartStep.items, tintColor: pieChartStep.stepContext.systemTintColor)
    }
    
    public func updatePieChart(items: [PieChartItem], tintColor: UIColor) {
        let entries = items.map {
            PieChartDataEntry(value: $0.value, label: $0.label)
        }
        let dataSet = PieChartDataSet(entries: entries, label: nil)
        let data = PieChartData(dataSets: [dataSet])
        self.pieChartView.data = data
        self.pieChartView.chartDescription?.text = nil
        
        // Colors
        dataSet.colors = tintColor.colorScheme(ofType: .analagous) as? [UIColor] ?? dataSet.colors
        
        dataSet.valueColors = [.white]
        dataSet.valueFont = .boldSystemFont(ofSize: 12)
        dataSet.entryLabelColor = .white
        dataSet.entryLabelFont = .boldSystemFont(ofSize: 12)
        self.pieChartView.drawHoleEnabled = false
        self.pieChartView.legend.enabled = false
        self.pieChartView.rotationEnabled = false
        
        self.pieChartView.notifyDataSetChanged()
    }
}
