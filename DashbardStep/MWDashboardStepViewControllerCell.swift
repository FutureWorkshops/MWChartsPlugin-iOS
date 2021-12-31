//
//  MWDashboardStepViewControllerCell.swift
//  MWChartsPlugin
//
//  Created by Xavi Moll on 30/12/21.
//

import Foundation

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
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.axis = .vertical
        self.stackView.spacing = 16
        self.stackView.alignment = .leading
        self.stackView.distribution = .fill
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            self.titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            self.stackView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16),
            self.stackView.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor),
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
    }
    
}
