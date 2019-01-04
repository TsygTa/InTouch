//
//  User.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 23.12.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class User: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var status: String = ""
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["uid"].intValue
        self.name = json["first_name"].stringValue
        self.image = json["photo_50"].stringValue
        self.status = json["status"].stringValue
    }
}

