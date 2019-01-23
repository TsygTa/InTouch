//
//  Group.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 23.12.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

final class Group: Object, Codable, VKFetchable {
    static var forUser: Bool = false
    static var query: String = ""
    
    static var path: String {
        get {
            if forUser {
                return "/method/groups.get"
            }
            return "/method/groups.search"
        }
    }
    
    static var parameters: Parameters {
        get {
            if forUser {
                return [
                    "user_id": Session.instance.userId,
                    "access_token": Session.instance.token,
                    "extended": "1",
                    "version": "5.92"
                ]
            }
            return [
                "q": self.query,
                "type": "group",
                "access_token": Session.instance.token,
                "version": "5.92"
            ]
        }
    }
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var isMember: Int = 0
    
    static func parseJSON(json: JSON) -> Group {
        let group = Group(json: json)
        return group
    }
    
    convenience init (id ind: Int, name str: String, image img: String, is_member is_m: Int) {
        self.init()
        self.id = ind
        self.name = str
        self.image = img
        self.isMember = is_m
    }
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["gid"].intValue
        self.name = json["name"].stringValue
        self.image = json["photo"].stringValue
        self.isMember = json["is_member"].intValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
