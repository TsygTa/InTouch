//
//  ParseData.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 24.02.2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift


class ParseData<Element: Object & VKFetchable>: Operation {
    
    var outputData: [Element] = []
    private var item: String
    
    init(item: String = "") {
        self.item = item
    }
    
    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataOperation,
            let data = getDataOperation.data else {return}
        
        let json = try? JSON(data: data)
        
        if !item.isEmpty {
            self.outputData = json?["response"][item].arrayValue.map { Element.parseJSON(json: $0) } ?? []
        } else {
            self.outputData = json?["response"].arrayValue.map { Element.parseJSON(json: $0) } ?? []
        }
    }
}
