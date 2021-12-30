//
//  MWDashboardStepViewControllerCell.swift
//  MWChartsPlugin
//
//  Created by Xavi Moll on 30/12/21.
//

import Foundation

class MWDashboardStepViewControllerCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    var stackView: UIStackView?
    var subtitleLabel: UILabel?
    var graphContainerView: UIView?
    var footerLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.numberOfLines = 0
        self.titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        self.contentView.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            self.titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            self.titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Clear title for the next cell
        self.titleLabel.text = nil
        
        // Remove from superview
        [stackView, subtitleLabel, graphContainerView, footerLabel].forEach {
            $0?.removeFromSuperview()
        }
        // Nullify references to free resources
        self.stackView = nil
        self.subtitleLabel = nil
        self.graphContainerView = nil
        self.footerLabel = nil
    }
    
    func configure(with item: DashboardItem) {
        self.titleLabel.text = item.title
    }
    
}
