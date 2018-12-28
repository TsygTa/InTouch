//
//  User.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 23.12.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: Codable {
    var id: Int
    var name: String
    var image: String
    var status: String
    
    var likes: Int = 0
    var liked: Bool = false
    
    init() {
        id = 0
        name = ""
        image = ""
        status = ""
        likes = 0
        liked = false
    }
    
    init(json: JSON) {
        self.id = json["uid"].intValue
        self.name = json["first_name"].stringValue
        self.image = json["photo_50"].stringValue
        self.status = json["status"].stringValue
    }
}

