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
import Alamofire

final class User: Object, Codable, VKFetchable {
    
    static var path: String {
        get {
            return "/method/friends.get"
        }
    }
    
    static var parameters: Parameters {
        get {
            return [
                "user_id": Session.instance.userId,
                "access_token": Session.instance.token,
                "fields": "nickname,status,photo_50",
                "version": "5.92"
            ]
        }
    }
    @objc dynamic var uuid: String = UUID().uuidString
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var status: String = ""
    
    static func parseJSON(json: JSON) -> User {
        let user = User(json: json)
        return user
    }
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["uid"].intValue
        self.name = json["first_name"].stringValue + " " + json["last_name"].stringValue
        self.image = json["photo_50"].stringValue
        self.status = json["status"].stringValue
    }
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
}

