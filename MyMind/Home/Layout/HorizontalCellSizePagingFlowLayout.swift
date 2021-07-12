//
//  HorizontalCellSizePagingFlowLayout.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/11.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class HorizontalCellSizePagingFlowLayout: UICollectionViewFlowLayout {
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollDirection = .horizontal
    }
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x
        let targetRect = CGRect(origin: CGPoint(x: proposedContentOffset.x, y: 0), size: self.collectionView!.bounds.size)

        for layoutAttributes in super.layoutAttributesForElements(in: targetRect)! {
            let itemOffset = layoutAttributes.frame.origin.x
            if (abs(itemOffset - horizontalOffset) < abs(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        }

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
