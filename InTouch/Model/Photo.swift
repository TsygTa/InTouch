//
//  Photo.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 23.12.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Photo: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var userId: Int = 0
    @objc dynamic var image: String = ""
    @objc dynamic var likes: Int = 0
    
    @objc dynamic var liked: Bool = false
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["pid"].intValue
        self.userId = json["owner_id"].intValue
        self.image = json["src"].stringValue
        self.likes = json["likes"]["count"].intValue
        self.liked = false
    }

}
