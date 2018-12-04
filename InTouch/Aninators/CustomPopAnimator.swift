//
//  CustomPopAnimator.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 03.12.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit

final class CustomPopAnimator:NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else {return}
        guard let destination = transitionContext.viewController(forKey: .to) else {return}
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        
        destination.view.frame = source.view.frame
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
            delay: 0, options: .calculationModePaced, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4, animations: {
                    source.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
                    source.view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
                })
        }, completion: { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.removeFromParent()
            } else if transitionContext.transitionWasCancelled {
                destination.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        })
    }
}
