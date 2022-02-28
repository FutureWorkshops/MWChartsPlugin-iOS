//
//  PinterestLayout.swift
//  MWChartsPlugin
//
//  Created by Jonathan Flintham on 25/02/2022.
//  Thanks to: http://www.raywenderlich.com/107439/uicollectionview-custom-layout-tutorial-pinterest
//

import UIKit

protocol PinterestLayoutHeightDataSource: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat
}

class PinterestLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var cellHeight: CGFloat = 0.0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! PinterestLayoutAttributes
        copy.cellHeight = self.cellHeight
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attributtes = object as? PinterestLayoutAttributes {
            if( attributtes.cellHeight == self.cellHeight  ) {
                return super.isEqual(object)
            }
        }
        return false
    }
}

class PinterestLayout: UICollectionViewLayout {

    weak var heightDataSource: PinterestLayoutHeightDataSource?
    
    var numberOfColumns = 3
    var cellPadding: CGFloat = 10.0
    var contentInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
    
    var contentHeight: CGFloat = 0.0
    var contentWidth: CGFloat {
        guard let collectionView = self.collectionView else { return 0.0 }
        return collectionView.bounds.width - (self.contentInsets.left + self.contentInsets.right)
    }
    var columnWidth: CGFloat {
        return self.contentWidth / CGFloat(self.numberOfColumns)
    }
    var cellWidth: CGFloat {
        return self.columnWidth - self.cellPadding * 2
    }
    
    private var attributesCache = [IndexPath: PinterestLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        
        let numberOfItems = self.collectionView?.numberOfItems(inSection: 0) ?? 0
        let numberOfCachedAttributes = self.attributesCache.count
        let numberOfUndeterminedAttributes = numberOfItems - numberOfCachedAttributes
        let numberOfRows = CGFloat(numberOfCachedAttributes / self.numberOfColumns)
        let numberOfUnderterminedRows = CGFloat(numberOfUndeterminedAttributes / self.numberOfColumns)
        let averageRowHeight = self.contentHeight / numberOfRows
        let estimatedAdditionalHeight = averageRowHeight.isNaN ? 0 : averageRowHeight * numberOfUnderterminedRows
        
        return CGSize(width: self.contentWidth, height: self.contentHeight + self.contentInsets.bottom + estimatedAdditionalHeight)
    }
    
    override class var layoutAttributesClass: AnyClass {
        return PinterestLayoutAttributes.self
    }
    
    private func columnAndRowForIndexPath(_ indexPath: IndexPath) -> (Int, Int) {
        let row = indexPath.row / self.numberOfColumns
        let column = indexPath.row % self.numberOfColumns
        return (column, row)
    }
    
    private func indexPathForColumn(_ column: Int, row: Int) -> IndexPath {
        let item = (row * self.numberOfColumns) + column
        return IndexPath(item: item, section: 0)
    }
    
    override func prepare() {
        super.prepare()
    
        self.contentHeight = 0.0
        self.attributesCache.removeAll()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView else { return nil }
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        var filledColumn = [Bool](repeatElement(false, count: self.numberOfColumns))
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            if let attributes = self.layoutAttributesForItem(at: indexPath) {
                if attributes.frame.intersects(rect) {
                    layoutAttributes.append(attributes)
                }
                
                if attributes.frame.maxY >= rect.maxY {
                    let (column, _) = self.columnAndRowForIndexPath(indexPath)
                    filledColumn[column] = true
                    let uniqueElements = Set(filledColumn)
                    if uniqueElements.count == 1 && uniqueElements.contains(true) {
                        break // all columns have passed extent of rect
                    }
                }
            }
        }
        
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = self.collectionView else { return nil }
        
        if let attributes = self.attributesCache[indexPath] {
            return attributes
        } else {
            let (column, row) = self.columnAndRowForIndexPath(indexPath)
            
            let yOffset: CGFloat
            
            if row == 0 {
                yOffset = self.contentInsets.top
            } else {
                let previousIndexPath = self.indexPathForColumn(column, row: row - 1)
                guard let previousAttributes = self.layoutAttributesForItem(at: previousIndexPath) else { // possible recursive action here
                    assertionFailure()
                    return nil
                }
                yOffset = previousAttributes.frame.maxY + self.cellPadding
            }
            
            let xOffset = self.contentInsets.left + CGFloat(column) * self.columnWidth
            let cellHeight = self.heightDataSource?.collectionView(collectionView, heightForCellAtIndexPath: indexPath, withWidth: self.cellWidth) ?? 0.0
            let height = cellHeight + self.cellPadding * 2
            let frame = CGRect(x: xOffset, y: yOffset, width: self.columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: self.cellPadding, dy: self.cellPadding)
            
            let attributes = PinterestLayoutAttributes(forCellWith: indexPath)
            attributes.cellHeight = cellHeight
            attributes.frame = insetFrame
            self.attributesCache[indexPath] = attributes
            
            self.contentHeight = max(self.contentHeight, frame.maxY)
            
            return attributes
        }
    }
}
