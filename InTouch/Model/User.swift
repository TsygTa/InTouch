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
                "fields": "nickname,status,photo_50,is_friend",
                "version": "5.92"
            ]
        }
    }
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var status: String = ""
    @objc dynamic var isFriend: Int = 0
    
    static func parseJSON(json: JSON) -> User {
        let user = User(json: json)
        return user
    }
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["uid"].intValue
        self.name = json["first_name"].stringValue + " " + json["last_name"].stringValue
        if !json["photo_50"].stringValue.isEmpty {
            self.image = json["photo_50"].stringValue
        } else if !json["photo_medium_rec"].stringValue.isEmpty {
            self.image = json["photo_medium_rec"].stringValue
        } else if !json["photo"].stringValue.isEmpty {
            self.image = json["photo"].stringValue
        } else {
            self.image = "emptyImage.png"
        }
        
        self.status = json["status"].stringValue
        self.isFriend = json["is_friend"].intValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

