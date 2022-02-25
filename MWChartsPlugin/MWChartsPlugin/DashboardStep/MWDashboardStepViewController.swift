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
    
        self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.collectionView)
        self.collectionView.register(MWDashboardStepViewControllerCell.self, forCellWithReuseIdentifier: "reuseIdentifier")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .clear
    }
    
    override func configureNavigationBar(_ navigationBar: UINavigationBar) {
        navigationItem.largeTitleDisplayMode = .automatic
        navigationBar.prefersLargeTitles = true
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let estimatedHeight: CGFloat = 50
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
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
