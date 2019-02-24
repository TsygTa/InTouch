//
//  GetDataOperation.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 24.02.2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import Foundation
import Alamofire

class GetDataOperation: AsyncOperation {
    private var request: DataRequest
    private var data: Data?
    
    init(_ request: DataRequest) {
        self.request = request
    }
    
    override func main() {
        request.responseData(queue: DispatchQueue.global()) { [weak self]
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
