//
//  FriendCell.swift
//  Weather
//
//  Created by Цыганкова Татьяна on 12.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit

class FriendCell: UICollectionViewCell {
    
    @IBOutlet weak var friendPhoto: UIImageView!
    @IBOutlet weak var friendLikes: LikeControl!
    
    var direction: Direction?
    
    var returnValue: ((_ value: Int)->())?
    
    override func prepareForReuse() {
        UIView.animateKeyframes(withDuration: 0.5, delay:0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
               self.friendPhoto.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }, completion: nil)
    }
}
