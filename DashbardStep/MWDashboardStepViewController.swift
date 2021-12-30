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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGroupedBackground
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 200)
        layout.sectionInset = .init(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(collectionView)
        
        collectionView.register(MWDashboardStepViewControllerCell.self, forCellWithReuseIdentifier: "reuseIdentifier")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
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

extension MWDashboardStepViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        
        // Remove the section insets on both sides
        var width = collectionView.frame.width - (flowLayout.sectionInset.left * 2)
        // Remove the inter item spacing horizontally
        width = width - flowLayout.minimumInteritemSpacing
        // Make sure that we can fit two cells in each row
        width = width / 2
        
        
        //TODO: Calculate the height for each cell
        return CGSize(width: width, height: 200)
    }
}
