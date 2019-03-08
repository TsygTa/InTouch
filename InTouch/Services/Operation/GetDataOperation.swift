//
//  GetDataOperation.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 24.02.2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class GetDataOperation: AsyncOperation {
    private var request: DataRequest
    private let baseUrl = "https://api.vk.com"
    var data: Data?
    
    init<Element: Object & VKFetchable>(type: Element.Type) {
        self.request = Alamofire.request(baseUrl + Element.path, method: .get,
             parameters: Element.parameters)
    }
    
    override func main() {
        request.responseJSON(queue: DispatchQueue.global()) { [weak self]
            response in
            
            guard let self = self else {return}
            
            self.data = response.data
            self.state = .finished
        }
    }
    
    override func cancel() {
        request.cancel()
        super.cancel()
    }
}
