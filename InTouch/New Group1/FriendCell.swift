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
}
