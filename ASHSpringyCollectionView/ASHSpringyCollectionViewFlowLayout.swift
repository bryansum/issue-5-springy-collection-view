//
//  ASHSpringyCollectionViewFlowLayout.swift
//  ASHSpringyCollectionView
//
//  Created by Ash Furrow on 2013-08-12.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

/*
 
 This implementation is based on https://github.com/TeehanLax/UICollectionView-Spring-Demo
 which I developed at Teehan+Lax. Check it out.
 
 */

import UIKit

class ASHSpringyCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var dynamicAnimator: UIDynamicAnimator!
    private var visibleIndexPathsSet: NSMutableSet!
    private var latestDelta: CGFloat = 0
    
    override init() {
        super.init()
        
        self.minimumInteritemSpacing = 10
        self.minimumLineSpacing = 10
        self.itemSize = CGSize(width: 44, height: 44)
        self.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
        self.visibleIndexPathsSet = NSMutableSet()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.minimumInteritemSpacing = 10
        self.minimumLineSpacing = 10
        self.itemSize = CGSize(width: 44, height: 44)
        self.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
        self.visibleIndexPathsSet = NSMutableSet()
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = self.collectionView else { return }
        
        // Need to overflow our actual visible rect slightly to avoid flickering.
        let visibleRect = CGRect(
            origin: collectionView.bounds.origin,
            size: collectionView.frame.size
        ).insetBy(dx: -100, dy: -100)
        
        let itemsInVisibleRectArray = super.layoutAttributesForElements(in: visibleRect) ?? []
        
        let itemsIndexPathsInVisibleRectSet = Set(itemsInVisibleRectArray.map { $0.indexPath })
        
        // Step 1: Remove any behaviours that are no longer visible.
        let noLongerVisibleBehaviours = self.dynamicAnimator.behaviors.filter { behavior in
            guard let attachmentBehavior = behavior as? UIAttachmentBehavior,
                  let item = attachmentBehavior.items.first as? UICollectionViewLayoutAttributes else {
                return false
            }
            let currentlyVisible = itemsIndexPathsInVisibleRectSet.contains(item.indexPath)
            return !currentlyVisible
        }
        
        for behavior in noLongerVisibleBehaviours {
            if let attachmentBehavior = behavior as? UIAttachmentBehavior,
               let item = attachmentBehavior.items.first as? UICollectionViewLayoutAttributes {
                self.dynamicAnimator.removeBehavior(behavior)
                self.visibleIndexPathsSet.remove(item.indexPath)
            }
        }
        
        // Step 2: Add any newly visible behaviours.
        // A "newly visible" item is one that is in the itemsInVisibleRect(Set|Array) but not in the visibleIndexPathsSet
        let newlyVisibleItems = itemsInVisibleRectArray.filter { item in
            return !self.visibleIndexPathsSet.contains(item.indexPath)
        }
        
        let touchLocation = collectionView.panGestureRecognizer.location(in: collectionView)
        
        for item in newlyVisibleItems {
            let center = item.center
            let springBehaviour = UIAttachmentBehavior(item: item, attachedToAnchor: center)
            
            springBehaviour.length = 0.0
            springBehaviour.damping = 0.8
            springBehaviour.frequency = 1.0
            
            // If our touchLocation is not (0,0), we'll need to adjust our item's center "in flight"
            if !touchLocation.equalTo(CGPoint.zero) {
                let yDistanceFromTouch = abs(touchLocation.y - springBehaviour.anchorPoint.y)
                let xDistanceFromTouch = abs(touchLocation.x - springBehaviour.anchorPoint.x)
                let scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0
                
                var newCenter = center
                if self.latestDelta < 0 {
                    newCenter.y += max(self.latestDelta, self.latestDelta * scrollResistance)
                } else {
                    newCenter.y += min(self.latestDelta, self.latestDelta * scrollResistance)
                }
                item.center = newCenter
            }
            
            self.dynamicAnimator.addBehavior(springBehaviour)
            self.visibleIndexPathsSet.add(item.indexPath)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.dynamicAnimator.items(in: rect) as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.dynamicAnimator.layoutAttributesForCell(at: indexPath)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = self.collectionView else { return false }
        
        let scrollView = collectionView
        let delta = newBounds.origin.y - scrollView.bounds.origin.y
        
        self.latestDelta = delta
        
        let touchLocation = collectionView.panGestureRecognizer.location(in: collectionView)
        
        for behavior in self.dynamicAnimator.behaviors {
            if let springBehaviour = behavior as? UIAttachmentBehavior {
                let yDistanceFromTouch = abs(touchLocation.y - springBehaviour.anchorPoint.y)
                let xDistanceFromTouch = abs(touchLocation.x - springBehaviour.anchorPoint.x)
                let scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0
                
                if let item = springBehaviour.items.first as? UICollectionViewLayoutAttributes {
                    var center = item.center
                    if delta < 0 {
                        center.y += max(delta, delta * scrollResistance)
                    } else {
                        center.y += min(delta, delta * scrollResistance)
                    }
                    item.center = center
                    
                    self.dynamicAnimator.updateItem(usingCurrentState: item)
                }
            }
        }
        
        return false
    }
}