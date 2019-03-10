//
//  GetParseSaveOperation.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 26.02.2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import RealmSwift

class GetParseSaveOperation<Element: Object & VKFetchable> {
    
    static func getParseSave(deleteSaved: Bool = false, completion: ((ParseData<Element>?,  SaveDataToRealm<Element>?) -> Void)? = nil) {
        
        let getDataOperation = GetDataOperation(type: Element.self)
        let parseData = ParseData<Element>()
        let saveDataToRealm = SaveDataToRealm<Element>(delete: deleteSaved)
        
        parseData.addDependency(getDataOperation)
        parseData.completionBlock = { [unowned parseData, unowned saveDataToRealm] in
            completion?(parseData, saveDataToRealm)
        }
        saveDataToRealm.addDependency(parseData)
        
        OperationQueue().addOperations([getDataOperation,parseData], waitUntilFinished: true)
        OperationQueue.main.addOperation(saveDataToRealm)
    }
}
