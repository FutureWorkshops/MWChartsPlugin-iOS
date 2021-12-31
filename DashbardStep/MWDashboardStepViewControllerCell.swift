//
//  MWDashboardStepViewControllerCell.swift
//  MWChartsPlugin
//
//  Created by Xavi Moll on 30/12/21.
//

import Foundation
import Charts

class MWDashboardStepViewControllerCell: UICollectionViewCell {
    
    //MARK: UIViews
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    private var subtitleLabel: UILabel?
    private var graphContainerView: UIView?
    private var footerLabel: UILabel?
    
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .secondarySystemGroupedBackground
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.numberOfLines = 0
        self.titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.titleLabel.textColor = .secondaryLabel
        self.titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        self.titleLabel.setContentHuggingPriority(.required, for: .vertical)
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.axis = .vertical
        self.stackView.spacing = 16
        self.stackView.alignment = .fill
        self.stackView.distribution = .fill
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            
            self.stackView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16),
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Clear title for the next cell
        self.titleLabel.text = nil
        
        // Remove from the stack view if present
        [self.subtitleLabel, self.graphContainerView, self.footerLabel].forEach {
            if let subview = $0 {
                stackView.removeArrangedSubview(subview)
                subview.removeFromSuperview()
            }
        }
        
        // Nullify references to free resources
        self.subtitleLabel = nil
        self.graphContainerView = nil
        self.footerLabel = nil
    }
    
    //MARK: Configuration
    func configure(with item: DashboardItem) {
        self.titleLabel.text = item.title
        
        if let subtitle = item.subtitle {
            self.subtitleLabel = UILabel()
            self.subtitleLabel?.translatesAutoresizingMaskIntoConstraints = false
            self.subtitleLabel?.numberOfLines = 0
            self.subtitleLabel?.font = UIFont.systemFont(ofSize: 34, weight: .medium)
            self.subtitleLabel?.textColor = .label
            self.subtitleLabel?.text = subtitle
            self.stackView.addArrangedSubview(self.subtitleLabel!)
        }
        
        if item.chartType != .none {
            self.graphContainerView = UIView()
            self.graphContainerView?.translatesAutoresizingMaskIntoConstraints = false
            self.stackView.addArrangedSubview(self.graphContainerView!)

            switch item.chartType {
            case .bar, .line:
                // Height is 0.6 times the width
                self.graphContainerView?.heightAnchor.constraint(equalTo: self.stackView.widthAnchor, multiplier: 0.6).isActive = true
                self.graphContainerView?.backgroundColor = .systemBlue
            case .pie:
                // Square
                self.graphContainerView?.heightAnchor.constraint(equalTo: self.stackView.widthAnchor).isActive = true
                let pieChartView = PieChartView()
                pieChartView.translatesAutoresizingMaskIntoConstraints = false
                self.graphContainerView?.addPinnedSubview(pieChartView)
                
                #warning("Hardcoded values")
                let entries = [
                    PieChartDataEntry(value: 10),
                    PieChartDataEntry(value: 30),
                    PieChartDataEntry(value: 60)
                ]
                let dataSet = PieChartDataSet(entries: entries, label: nil)
                dataSet.drawValuesEnabled = false
                let data = PieChartData(dataSets: [dataSet])
                pieChartView.data = data
                pieChartView.chartDescription?.text = nil
                
                // Colors
                dataSet.colors = tintColor.colorScheme(ofType: .analagous) as? [UIColor] ?? dataSet.colors
                pieChartView.drawHoleEnabled = false
                pieChartView.legend.enabled = false
                pieChartView.rotationEnabled = false
                pieChartView.notifyDataSetChanged()
            case .none:
                break
            }
        }
        
        if let footer = item.footer {
            self.footerLabel = UILabel()
            self.footerLabel?.translatesAutoresizingMaskIntoConstraints = false
            self.footerLabel?.numberOfLines = 0
            self.footerLabel?.font = UIFont.systemFont(ofSize: 15)
            self.footerLabel?.textColor = .secondaryLabel
            self.footerLabel?.text = footer
            self.stackView.addArrangedSubview(self.footerLabel!)
        }
    }
    
}
