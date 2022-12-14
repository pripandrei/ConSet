//
//  CardBehavior.swift
//  Set_Game
//
//  Created by Andrei Pripa on 11/2/22.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    
    func push(_ item: UIDynamicItem) {
        collision.translatesReferenceBoundsIntoBoundary = false
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        if let referenceBounds = dynamicAnimator?.referenceView?.bounds {
            let center = CGPoint(x: referenceBounds.midX, y: referenceBounds.midY)
            switch (item.center.x, item.center.y) {
            case let (x, y) where x < center.x && y < center.y:
                push.angle = (CGFloat.pi/2)
            case let (x, y) where x > center.x && y < center.y:
                push.angle = CGFloat.pi-(CGFloat.pi/2)
            case let (x, y) where x < center.x && y > center.y:
                push.angle = (-CGFloat.pi/2)
            case let (x, y) where x > center.x && y > center.y:
                push.angle = CGFloat.pi+(CGFloat.pi/2)
            default:
                push.angle = (CGFloat.pi*2)
            }
        }
        
        push.magnitude = CGFloat(1.0) + CGFloat(2.0)
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    lazy var collision: UICollisionBehavior = {
        let collisionBehavior = UICollisionBehavior()
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        return collisionBehavior
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = true
        behavior.elasticity = 1.1
        behavior.resistance = 0.0
        return behavior
    }()
    
    var toggleItemBehaviours: Bool = true {
        didSet {
            if toggleItemBehaviours {
                itemBehavior.elasticity = 3.5
                collision.translatesReferenceBoundsIntoBoundary = false
            } else {
                itemBehavior.elasticity = 1.1
                collision.translatesReferenceBoundsIntoBoundary = true
            }
        }
    }
    
    private func itemPush(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = CGFloat.pi * CGFloat.random(in: 1...5)
        push.magnitude = 7
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    private func snapBehavior(_ item: UIDynamicItem, _ point: CGPoint) {
        let snapBehavior = UISnapBehavior(item: item, snapTo: point)
        addChildBehavior(snapBehavior)
    }
    
    func addItem(_ item: UIDynamicItem) {
        collision.addItem(item)
        itemBehavior.addItem(item)
        itemPush(item)
    }
    
    func addSnapItem(_ item: UIDynamicItem, _ point: CGPoint) {
        snapBehavior(item, point)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        collision.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        addChildBehavior(collision)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(_ animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}


//    lazy var pushItem: UIPushBehavior = {
//        let push = UIPushBehavior()
//        push.removeItem(previous)
//        push.angle = CGFloat.pi * CGFloat.random(in: 1...5)
//        push.magnitude = 1.1
//        push.active = true
////        push.action = { [unowned push] in
////            push.dynamicAnimator?.removeBehavior(push)
////        }
//            animator.addBehavior(push)
//        previous = senderItem
//        return push
//        }()
