//
//  Group.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 23.12.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import RealmSwift

class Group: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var image: String = ""
    
    
    convenience init (id ind: Int, name str: String, image img: String) {
        self.init()
        self.id = ind
        self.name = str
        self.image = img
    }
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["gid"].intValue
        self.name = json["name"].stringValue
        self.image = json["photo"].stringValue
    }
}
