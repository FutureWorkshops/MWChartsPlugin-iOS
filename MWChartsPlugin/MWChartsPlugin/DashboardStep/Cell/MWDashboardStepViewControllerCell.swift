//
//  MWDashboardStepViewControllerCell.swift
//  MWChartsPlugin
//
//  Created by Xavi Moll on 30/12/21.
//

import Foundation
import Charts
import Colours
import MobileWorkflowCore

class MWDashboardStepViewControllerCell: UICollectionViewCell {
    
    private let stackViewInset: CGFloat = 16
    
    //MARK: UIViews
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    private var subtitleLabel: UILabel?
    private var graphContainerView: UIView?
    private var footerLabel: UILabel?
    
    var theme: Theme = .current {
        didSet {
            self.configureStyle(theme: self.theme)
        }
    }
    
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.axis = .vertical
        self.stackView.spacing = 2
        self.stackView.alignment = .fill
        self.stackView.distribution = .fill
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.numberOfLines = 0
        self.titleLabel.adjustsFontForContentSizeCategory = true
        self.titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        self.titleLabel.setContentHuggingPriority(.required, for: .vertical)
        self.stackView.addArrangedSubview(self.titleLabel)
        
        self.contentView.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: self.stackViewInset),
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: self.stackViewInset),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -self.stackViewInset),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -self.stackViewInset)
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.configureStyle(theme: self.theme)
    }
    
    //MARK: Configuration
    func configureStyle(theme: Theme) {
        
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        self.subtitleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        self.footerLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        
        let backgroundView = UIView(frame: self.bounds)
        backgroundView.backgroundColor = theme.groupedCellBackgroundColor
        backgroundView.layer.cornerRadius = 10
        self.backgroundView = backgroundView
        
        let selectedBackgroundView = UIView(frame: self.bounds)
        selectedBackgroundView.backgroundColor = theme.groupedCellBackgroundColor.darken(0.2)
        selectedBackgroundView.layer.cornerRadius = 10
        self.selectedBackgroundView = selectedBackgroundView
        
        self.titleLabel.textColor = theme.secondaryTextColor
        self.subtitleLabel?.textColor = theme.primaryTextColor
        self.footerLabel?.textColor = theme.secondaryTextColor
    }
    
    func configure(with item: DashboardStepItem, theme: Theme) {
        
        self.titleLabel.text = item.title
        
        if let text = item.text {
            self.subtitleLabel = UILabel()
            self.subtitleLabel?.translatesAutoresizingMaskIntoConstraints = false
            self.subtitleLabel?.numberOfLines = 0
            self.subtitleLabel?.adjustsFontForContentSizeCategory = true
            
            self.subtitleLabel?.text = text
            self.subtitleLabel?.setContentCompressionResistancePriority(.required, for: .vertical)
            self.subtitleLabel?.setContentHuggingPriority(.required, for: .vertical)
            self.stackView.addArrangedSubview(self.subtitleLabel!)
        }
        
        if item.chartType != .statistic {
            self.graphContainerView = UIView()
            self.graphContainerView?.translatesAutoresizingMaskIntoConstraints = false
            self.stackView.addArrangedSubview(self.graphContainerView!)

            switch item.chartType {
            case .bar:
                // Height is 0.6 times the width
                self.graphContainerView?.heightAnchor.constraint(equalTo: self.stackView.widthAnchor, multiplier: 0.6).isActive = true
                
                let entries = item.chartValues?.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: $0.element) } ?? []
                
                let dataSet = BarChartDataSet(entries: entries)
                dataSet.drawValuesEnabled = false
                dataSet.drawIconsEnabled = false
                dataSet.colors = item.colors ?? [theme.primaryTintColor]

                let chart = BarChartView()
                chart.translatesAutoresizingMaskIntoConstraints = false
                chart.isUserInteractionEnabled = false
                chart.drawGridBackgroundEnabled = false
                chart.drawMarkers = false
                chart.drawBordersEnabled = false
                chart.pinchZoomEnabled = false
                chart.doubleTapToZoomEnabled = false
                chart.rightAxis.enabled = false
                chart.leftAxis.enabled = false
                chart.xAxis.drawAxisLineEnabled = false
                chart.xAxis.drawLabelsEnabled = false
                chart.xAxis.drawGridLinesEnabled = false
                chart.legend.enabled = false
                chart.data = BarChartData(dataSet: dataSet)
                chart.notifyDataSetChanged()
                
                self.graphContainerView?.addPinnedSubview(chart)
            case .line:
                // Height is 0.6 times the width
                self.graphContainerView?.heightAnchor.constraint(equalTo: self.stackView.widthAnchor, multiplier: 0.6).isActive = true
                
                let entries = item.chartValues?.enumerated().map { ChartDataEntry(x: Double($0.offset), y: $0.element) } ?? []
                
                let dataSet = LineChartDataSet(entries: entries)
                dataSet.drawValuesEnabled = false
                dataSet.drawCirclesEnabled = false
                dataSet.drawFilledEnabled = false
                dataSet.drawIconsEnabled = false
                dataSet.drawVerticalHighlightIndicatorEnabled = false
                dataSet.drawHorizontalHighlightIndicatorEnabled = false
                dataSet.lineWidth = 2
                dataSet.colors = item.colors ?? [theme.primaryTintColor]
                
                let chart = LineChartView()
                chart.translatesAutoresizingMaskIntoConstraints = false
                chart.isUserInteractionEnabled = false
                chart.drawGridBackgroundEnabled = false
                chart.drawMarkers = false
                chart.drawBordersEnabled = false
                chart.pinchZoomEnabled = false
                chart.doubleTapToZoomEnabled = false
                chart.rightAxis.enabled = false
                chart.leftAxis.enabled = false
                chart.xAxis.drawAxisLineEnabled = false
                chart.xAxis.drawLabelsEnabled = false
                chart.xAxis.drawGridLinesEnabled = false
                chart.legend.enabled = false
                chart.data = LineChartData(dataSet: dataSet)
                chart.notifyDataSetChanged()
                
                self.graphContainerView?.addPinnedSubview(chart)
            case .pie:
                // Square
                self.graphContainerView?.heightAnchor.constraint(equalTo: self.stackView.widthAnchor).isActive = true
                
                let entries = item.chartValues?.map { PieChartDataEntry(value: $0) } ?? []
                
                let dataSet = PieChartDataSet(entries: entries, label: "")
                dataSet.drawValuesEnabled = false
                dataSet.colors = item.colors ?? theme.primaryTintColor.colorScheme(ofType: .analagous) as? [UIColor] ?? dataSet.colors
                
                let pieChartView = PieChartView()
                pieChartView.translatesAutoresizingMaskIntoConstraints = false
                pieChartView.isUserInteractionEnabled = false
                pieChartView.chartDescription.text = ""
                pieChartView.drawHoleEnabled = false
                pieChartView.legend.enabled = false
                pieChartView.rotationEnabled = false
                pieChartView.data = PieChartData(dataSet: dataSet)
                pieChartView.notifyDataSetChanged()
                
                self.graphContainerView?.addPinnedSubview(pieChartView)
            case .statistic:
                break
            }
        }
        
        if let footer = item.footer {
            self.footerLabel = UILabel()
            self.footerLabel?.translatesAutoresizingMaskIntoConstraints = false
            self.footerLabel?.numberOfLines = 0
            self.footerLabel?.adjustsFontForContentSizeCategory = true
            self.footerLabel?.text = footer
            self.footerLabel?.setContentCompressionResistancePriority(.required, for: .vertical)
            self.footerLabel?.setContentHuggingPriority(.required, for: .vertical)
            self.stackView.addArrangedSubview(self.footerLabel!)
        }
        
        self.theme = theme // will trigger configureStyle
    }
    
    //MARK: Layout helper
    func layoutSizeFittingWidth(width: CGFloat) -> CGSize {
        let widthConstraint = self.stackView.widthAnchor.constraint(equalToConstant: width - (2 * self.stackViewInset))
        widthConstraint.isActive = true
        let size = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        widthConstraint.isActive = false
        return size
    }
}
