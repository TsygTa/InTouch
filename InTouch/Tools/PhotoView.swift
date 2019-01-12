//
//  PhotoView.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 25.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit

class PhotoView: PlainImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    @objc func onTap() {
        animatePhoto()
    }
    
    func animatePhoto() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 1
        animation.toValue = 0.7
        animation.stiffness = 100
        animation.mass = 2
        animation.beginTime = CACurrentMediaTime() + 0.3
        animation.fillMode = CAMediaTimingFillMode.backwards
        self.layer.add(animation, forKey: nil)
    }
}
