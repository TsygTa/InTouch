//
//  NetworkService.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 20.12.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NetworkingService {
    
    let baseUrl = "https://api.vk.com"
    
    static func urlForIcon(_ icon: String) -> URL? {
        return URL(string: icon)
    }
    
    func fetch<Element: VKFetchable>(completion: (([Element]?, Error?) -> Void)? = nil) {
        Alamofire.request(baseUrl + Element.path, method: .get,
                          parameters: Element.parameters).responseJSON {
            response in
            switch response.result {
            case .failure(let error):
                completion?(nil,error)
            case .success(let value):
                let json = JSON(value)
                let elements: [Element] = json["response"].arrayValue.map { Element.parseJSON(json: $0) }
                completion?(elements, nil)
            }
        }
    }
    
    public func authorizeRequest() -> URLRequest {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6794724"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "270342"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.92"),
            URLQueryItem(name: "state", value: "123456")
        ]
        return URLRequest(url: urlComponents.url!)
    }
    
    enum likeAction {
        case add
        case delete
    }
    
    func pushLikeRequest(action: likeAction, ownerId: Int, itemId: Int, itemType: String, completion: ((Int?, Error?) -> Void)? = nil) {
        
        let path: String
        switch action {
            case .add:
                path = baseUrl + "/method/likes.add"
            case .delete:
                path = baseUrl + "/method/likes.delete"
        }
        let parameters: Parameters = [
            "type": itemType,
            "owner_id": ownerId,
            "item_id": itemId,
            "access_token": Session.instance.token,
            "version": "5.92"
        ]
        Alamofire.request(path, method: .get, parameters: parameters).responseJSON {
            response in
            switch response.result {
                case .failure(let error):
                    completion?(nil, error)
                case .success(let value):
                    let json = JSON(value)
                    let likes = json["response"]["likes"].intValue
                    completion?(likes, nil)
            }
        }
    }
    
    func groupJoinRequest(groupId: Int, completion: ((Int?, Error?) -> Void)? = nil) {
        
        let path = baseUrl + "/method/groups.join"
        
        let parameters: Parameters = [
            "group_id": groupId,
            "access_token": Session.instance.token,
            "version": "5.92"
        ]
        Alamofire.request(path, method: .get, parameters: parameters).responseJSON {
            response in
            switch response.result {
            case .failure(let error):
                completion?(nil, error)
            case .success(let value):
                let json = JSON(value)
                let result = json["response"].intValue
                completion?(result, nil)
            }
        }
    }
    
    func groupLeaveRequest(groupId: Int, completion: ((Int?, Error?) -> Void)? = nil) {
        
        let path = baseUrl + "/method/groups.leave"
        
        let parameters: Parameters = [
            "group_id": groupId,
            "access_token": Session.instance.token,
            "version": "5.92"
        ]
        Alamofire.request(path, method: .get, parameters: parameters).responseJSON {
            response in
            switch response.result {
            case .failure(let error):
                completion?(nil, error)
            case .success(let value):
                let json = JSON(value)
                let result = json["response"].intValue
                completion?(result, nil)
            }
        }
    }
}
