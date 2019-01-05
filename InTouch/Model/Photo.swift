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
import Alamofire

final class Photo: Object, Codable, VKFetchable {
    @objc dynamic static var userIdParameter: Int = 0
    @objc dynamic static var path: String {
        get {
            return "/method/photos.get"
        }
    }
    
    @objc dynamic static var parameters: Parameters {
        get {
            return [
                "owner_id": self.userIdParameter,
                "album_id": "profile",
                "access_token": Session.instance.token,
                "extended": "1",
                "version": "5.92"
            ]
        }
    }
    
    @objc dynamic var id: Int = 0
    @objc dynamic var userId: Int = 0
    @objc dynamic var image: String = ""
    @objc dynamic var likes: Int = 0
    
    @objc dynamic var liked: Bool = false
    
    static func parseJSON(json: JSON) -> Photo {
        let photo = Photo(json: json)
        return photo
    }
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["pid"].intValue
        self.userId = json["owner_id"].intValue
        self.image = json["src"].stringValue
        self.likes = json["likes"]["count"].intValue
        self.liked = false
    }

}
