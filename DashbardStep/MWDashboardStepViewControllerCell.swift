//
//  MWDashboardStepViewControllerCell.swift
//  MWChartsPlugin
//
//  Created by Xavi Moll on 30/12/21.
//

import Foundation

class MWDashboardStepViewControllerCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
