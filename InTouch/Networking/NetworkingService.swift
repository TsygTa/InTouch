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
    static let shareManager: SessionManager = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        config.timeoutIntervalForRequest = 40
        
        let manager = Alamofire.SessionManager(configuration: config)
        return manager
    }()
    
    public func sendRequest() {
        let params: Parameters = [
            
        ]
        NetworkingService.shareManager.request(baseURL+path, method: .get, parameters: params).responseJSON { response in
            guard let value = response.value else {return}
            print(value)
        }
    }
}
