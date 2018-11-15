//
//  MyImageView.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 14.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit

@IBDesignable class RoundImageView: UIImageView {
    
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
             self.awakeFromNib()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 6 {
        didSet {
             self.awakeFromNib()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize.zero {
        didSet {
             self.awakeFromNib()
        }
    }
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 2
        layer.borderColor = UIColor.red.cgColor
        
        layer.cornerRadius = self.frame.size.width / 2.0
        layer.masksToBounds = false
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
    }

}
