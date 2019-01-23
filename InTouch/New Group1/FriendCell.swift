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
    
    public func configure(with photo: Photo, delegate vc: FriendDelegate) {
        
        self.friendPhoto.kf.setImage(with: NetworkingService.urlForIcon(photo.image))
        self.friendLikes.delegate = vc
        self.friendLikes.setCounter(photo.likes)
        self.friendLikes.setLiked(photo.liked)
    }
}
