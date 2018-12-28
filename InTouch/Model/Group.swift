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

class Group: Codable {
    var id: Int
    var name: String
    var image: String
    
//    init() {
//        id = 0
//        name = ""
//        image = ""
//    }
    
    init (id ind: Int, name str: String, image img: String) {
        self.id = ind
        self.name = str
        self.image = img
    }
    
    init(json: JSON) {
        self.id = json["gid"].intValue
        self.name = json["name"].stringValue
        self.image = json["photo"].stringValue
    }
}
