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
        return 1.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else {return}
        guard let destination = transitionContext.viewController(forKey: .to) else {return}
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        
        destination.view.frame = source.view.frame
        //destination.view.layer.anchorPoint = CGPoint(x: source.view.frame.width, y: 0)
        //destination.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
            delay: 0, options: .calculationModePaced, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4, animations: {
                    let translation = CGAffineTransform(translationX: source.view.frame.width/2, y: -source.view.frame.width/2)
                    source.view.transform = translation.concatenating(CGAffineTransform(rotationAngle: CGFloat.pi/4))
                })
                UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.4, animations: {
                    let translation = CGAffineTransform(translationX: 0, y: 0)
                    source.view.transform = translation.concatenating(CGAffineTransform(rotationAngle: CGFloat.pi/4))
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.4, animations: {
                    destination.view.transform = .identity
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
