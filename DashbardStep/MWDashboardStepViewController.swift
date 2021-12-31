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
        
        let layout = PinterestLayout()
        layout.delegate = self
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(collectionView)
        
        collectionView.register(MWDashboardStepViewControllerCell.self, forCellWithReuseIdentifier: "reuseIdentifier")
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

extension MWDashboardStepViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        //TODO: Find a way to calculate the correct height!
        return [150, 200].randomElement()!
    }
}
