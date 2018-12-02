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
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else {return}
        guard let destination = transitionContext.viewController(forKey: .to) else {return}
        
        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = source.view.frame
        let translation = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        destination.view.transform = translation.concatenating(CGAffineTransform(translationX: source.view.frame.width, y: -source.view.frame.width))
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0, options: .calculationModePaced, animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4) {
                                        let translation = CGAffineTransform(rotationAngle: -CGFloat.pi/8)
                                        destination.view.transform = translation.concatenating(CGAffineTransform(translationX: source.view.frame.width/2, y: -source.view.frame.width))
                                    }
//                                    UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.4) {
//                                        let translation = CGAffineTransform(rotationAngle: -CGFloat.pi/8)
//                                        destination.view.transform = translation.concatenating(CGAffineTransform(translationX: 0, y: 0))
//                                    }
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.4) {
                                        destination.view.transform = .identity
                                    }
        }, completion: { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        })
    }
}
