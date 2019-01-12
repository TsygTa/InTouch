//
//  RoundImageView.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 13.01.2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import UIKit
class RoundImageView: UIImageView {
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = self.frame.size.width / 2.0
        layer.masksToBounds = true
        
    }
}
