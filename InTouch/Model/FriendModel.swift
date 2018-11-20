//
//  File.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 20.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit

struct FriendModel {
    var name: String
    var image: UIImage
    var likes: Int
    var liked: Bool
    
    init (name str: String, image img: UIImage, likes lks: Int, liked lkd: Bool) {
        self.name = str
        self.image = img
        self.likes = lks
        self.liked = lkd
    }
    
    init (name str: String, image img: UIImage) {
        self.name = str
        self.image = img
        self.likes = 0
        self.liked = false
    }
}
