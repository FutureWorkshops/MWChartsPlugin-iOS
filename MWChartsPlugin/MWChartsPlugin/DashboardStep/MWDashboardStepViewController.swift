//
//  MWDashboardStepViewController.swift
//  MWChartsPlugin
//
//  Created by Xavi Moll on 30/12/21.
//

import UIKit
import Foundation
import MobileWorkflowCore

class MWDashboardStepViewController: MWStepViewController {
    
    var dashboardStep: MWDashboardStep { self.mwStep as! MWDashboardStep }
    var collectionView: UICollectionView!
    let spacing: CGFloat = 16.0
    
    var heightWorkerCell: MWDashboardStepViewControllerCell!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGroupedBackground
    
        self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.collectionView)
        self.collectionView.register(MWDashboardStepViewControllerCell.self, forCellWithReuseIdentifier: "reuseIdentifier")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .clear
        
        self.heightWorkerCell = MWDashboardStepViewControllerCell(frame: .zero)
    }
    
    override func configureNavigationBar(_ navigationBar: UINavigationBar) {
        navigationItem.largeTitleDisplayMode = .automatic
        navigationBar.prefersLargeTitles = true
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = PinterestLayout()
        layout.numberOfColumns = 2
        layout.cellPadding = 6
        layout.contentInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.heightDataSource = self
        return layout
    }
}

extension MWDashboardStepViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dashboardStep.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseIdentifier", for: indexPath) as? MWDashboardStepViewControllerCell else { fatalError("Invalid cell.") }
        let item = self.dashboardStep.items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

extension MWDashboardStepViewController: PinterestLayoutHeightDataSource {
    
    func collectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        let item = self.dashboardStep.items[indexPath.row]
        
        self.heightWorkerCell.prepareForReuse()
        self.heightWorkerCell.configure(with: item)
        let size = self.heightWorkerCell.layoutSizeFittingWidth(width: withWidth)
        
        return size.height
    }
}

extension MWDashboardStepViewController: UICollectionViewDelegate {
    
}
