//
//  ScaleImageView.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 26.02.2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import UIKit

class ScaledImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        
        if let originalImage = image {
            let width = originalImage.size.width
            let height = originalImage.size.height
            let scaledWidth = frame.size.width
            
            let ratio = scaledWidth/width
            let scaledHeight = height * ratio
            
            return CGSize(width: scaledWidth, height: scaledHeight)
        }
        
        return .zero
    }
}
