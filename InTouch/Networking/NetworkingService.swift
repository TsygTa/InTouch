//
//  NetworkService.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 20.12.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit
import Alamofire

class NetworkingService {
    
    let baseUrl = "https://api.vk.com"
    
    public func authorizeRequest() -> URLRequest {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6794724"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.92"),
            URLQueryItem(name: "state", value: "123456")
        ]
        return URLRequest(url: urlComponents.url!)
    }
    
    public func loadUserGroups() {
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token": Session.instance.token,
            "extended": "1",
            "version": "5.92"
        ]
        Alamofire.request(baseUrl+path, method: .get, parameters: params).responseJSON {
            (response) in
            switch response.result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let value):
                print(value)
            }
        }
    }
    
    public func loadUserFriends(offset of: Int = 0, count c: Int = 20) {
        let path = "/method/friends.get"
        
        let params: Parameters = [
            "user_id": Session.instance.userId,
            "order": "name",
            "offset": of,
            "count": c,
            "access_token": Session.instance.token,
            "fields": "nickname,photo_50",
            "version": "5.92"
        ]
        Alamofire.request(baseUrl+path, method: .get, parameters: params).responseJSON {
            (response) in
            switch response.result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let value):
                print(value)
            }
        }
    }
    
    public func loadFriendPhoto(_ id: Int, offset of: Int = 0, count c: Int = 20) {
        let path = "/method/photos.getUserPhotos"
        
        let params: Parameters = [
            "user_id": id,
            "offset": of,
            "count": c,
            "access_token": Session.instance.token,
            "extended": "1",
            "version": "5.92"
        ]
        Alamofire.request(baseUrl+path, method: .get, parameters: params).responseJSON {
            (response) in
            switch response.result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let value):
                print(value)
            }
        }
    }
    
    public func loadGroups(_ quiry: String, offset of: Int = 0, count c: Int = 20) {
        let path = "/method/groups.search"
        
        let params: Parameters = [
            "q": quiry,
            "type": "group",
            "access_token": Session.instance.token,
            "offset": of,
            "count": c,
            "version": "5.92"
        ]
        
        Alamofire.request(baseUrl+path, method: .get, parameters: params).responseJSON {
            (response) in
            switch response.result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let value):
                print(value)
            }
        }
    }
}
