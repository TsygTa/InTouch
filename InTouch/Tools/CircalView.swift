//
//  CircalView.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 26.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit

class CircalView: UIView {
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    override func awakeFromNib() {
        layer.backgroundColor = UIColor.blue.cgColor
        layer.cornerRadius = self.frame.size.width / 2.0
        layer.masksToBounds = false
        layer.opacity = 0
    }
}
