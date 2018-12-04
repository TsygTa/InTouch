//
//  CustomPushAnimator.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 02.12.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit

final class CustomPushAnimator:NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else {return}
        guard let destination = transitionContext.viewController(forKey: .to) else {return}
        
        transitionContext.containerView.addSubview(destination.view)
        
        destination.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        destination.view.frame = source.view.frame
        destination.view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
            delay: 0, options: .calculationModePaced, animations: {

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4, animations: {
                    destination.view.transform = .identity
            })
        }, completion: { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
                source.view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            } 
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
        )
    }
}
