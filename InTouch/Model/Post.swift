//
//  PostModel.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 05.02.2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
import Alamofire

final class Post: Codable, VKFetchable {
    static var path: String {
        get {
            return "/method/newsfeed.get"
        }
    }
    static var parameters: Parameters {
        get {
            return [
                "filters": "post,photo",
                "access_token": Session.instance.token,
                "return_banned": "0",
                "start_time": String(format:"%d", NSDate().timeIntervalSince1970 - 30*24*60*60),
                "fields": "first_name,last_name,name,deactivated,is_closed,is_friend",
                "version": "5.92"
            ]
        }
    }
    var type: String = "post"
    var date: Double = 0
    var post: String = ""
    var photo: String = ""
    var photoWidth: Int = 1
    var photoHeight: Int = 1
    
    var authorId: Int = 0
    var user: User?
    var group: Group?
    
    var likes: Int = 0
    var canLike: Bool = false
    var liked: Bool = false
    
    var canComment: Bool = false
    var comments: Int = 0
    
    var canRepost: Bool = false
    var reposts: Int = 0
    var reposted: Bool = false
    
    var views: Int = 0
    
    static func parseJSON(json: JSON) -> Post {
        let post = Post(json: json)
        return post
    }
    
    convenience init(json: JSON) {
        self.init()

        self.type = json["type"].stringValue
        self.date = json["date"].doubleValue
        self.authorId = json["source_id"].intValue
        DispatchQueue.main.async {
            if self.authorId < 0, let item = DatabaseService.getData(type: Group.self)?.filter("id = %d",-self.authorId) {
                if item.count > 0 {
                    self.group = Array(item)[0]
                }
            } else if self.authorId > 0, let item = DatabaseService.getData(type: User.self)?.filter("id = %d", self.authorId) {
                if item.count > 0 {
                    self.user = Array(item)[0]
                }
            }
        }
        
        if self.type == "post" {
            
            self.post = json["text"].stringValue
            
            if !json["attachment"]["photo"]["src_xbig"].stringValue.isEmpty {
                self.photo = json["attachment"]["photo"]["src_xbig"].stringValue
            } else if !json["attachment"]["photo"]["src_big"].stringValue.isEmpty {
                self.photo = json["attachment"]["photo"]["src_big"].stringValue
            } else {
                self.photo = json["attachment"]["photo"]["src"].stringValue
            }
            
            self.photoWidth = json["attachment"]["photo"]["width"].intValue
            self.photoHeight = json["attachment"]["photo"]["height"].intValue
            
            self.likes = json["likes"]["count"].intValue
            self.canLike = json["likes"]["can_like"].intValue  == 1 ? true : false
            self.liked = json["likes"]["user_likes"].intValue  == 1 ? true : false
            
            self.canRepost = json["likes"]["can_publish"].intValue  == 1 ? true : false
            self.reposts = json["reposts"]["count"].intValue
            self.reposted = json["reposts"]["user_reposted"].intValue  == 1 ? true : false
            
            self.canComment = json["comments"]["can_post"].intValue  == 1 ? true : false
            self.comments = json["comments"]["count"].intValue
            
            self.views = json["views"]["count"].intValue
            
        } else if self.type == "photo" {
            
            for photo in json["photos"].arrayValue {
                if photo["pid"].intValue > 0 {
                    self.photo = photo["src_big"].stringValue
                    self.photoWidth = photo["width"].intValue
                    self.photoHeight = photo["height"].intValue
                    
                    self.likes = photo["likes"]["count"].intValue
                    self.canLike = true
                    self.liked = photo["likes"]["user_likes"].intValue  == 1 ? true : false
                    
                    self.canRepost = photo["can_repost"].intValue  == 1 ? true : false
                    self.reposts = photo["reposts"]["count"].intValue
                    self.reposted = photo["reposts"]["user_reposted"].intValue  == 1 ? true : false
                    
                    self.canComment = photo["can_comment"].intValue  == 1 ? true : false
                    self.comments = photo["comments"]["count"].intValue
                    break
                }
            }
        }
        
    }
}
