//
//  ColletionViewLayout.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import UIKit

protocol ColletionViewLayoutDelegate: class {
    func collectionView(_ collectionView:UICollectionView, heightForItemAtIndexPath indexPath:IndexPath, itemWidth: CGFloat) -> CGFloat
}

class ColletionViewLayout: UICollectionViewLayout {
    
    weak var delegate: ColletionViewLayoutDelegate?
    
    private var numberOfColumns: Int = 2
    private var cellPadding: CGFloat = 4
    
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    func refreshLayout() {
        contentHeight = 0
        layoutAttributes.removeAll()
    }
    
}

extension ColletionViewLayout {
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        
        guard layoutAttributes.isEmpty, let collectionView = collectionView else {
            return
        }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffsets = [CGFloat]()
        
        (0..<numberOfColumns).forEach { (column) in
            xOffsets.append(CGFloat(column) * columnWidth)
        }
        
        var yOffsets = [CGFloat](repeating: 0, count: numberOfColumns)
        
        (0..<collectionView.numberOfItems(inSection: 0)).forEach { (itemIndex) in
            
            //Calculate height
            let indexPath = IndexPath(item: itemIndex, section: 0)
            let itemHeight = delegate?.collectionView(collectionView, heightForItemAtIndexPath: indexPath, itemWidth: columnWidth - 2 * cellPadding) ?? 0
            let height = cellPadding * 2 + itemHeight
            
            //Determine column to put item
            var minY: CGFloat = CGFloat.greatestFiniteMagnitude
            var minYColumn: Int = 0
            
            (0..<yOffsets.count).forEach({ (colum) in
                
                if yOffsets[colum] < minY {
                    minY = yOffsets[colum]
                    minYColumn = colum
                }
                
            })
            
            //Create attributes
            let frame = CGRect(x: xOffsets[minYColumn], y: yOffsets[minYColumn], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            layoutAttributes.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffsets[minYColumn] = yOffsets[minYColumn] + height
            
        }
        
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return layoutAttributes.filter { (attributes) -> Bool in
            
            return attributes.frame.intersects(rect)
            
        }
        
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.item]
    }
    
}
