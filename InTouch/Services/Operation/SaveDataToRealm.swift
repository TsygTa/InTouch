//
//  SaveDataToRealm.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 24.02.2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class SaveDataToRealm<Element: Object & VKFetchable>: Operation {
    
    var parseData: [Element] = []
    
    private var config: Realm.Configuration
    private var delete: Bool
    
    init(config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true), delete:Bool = false) {
        self.config = config
        self.delete = delete
    }
    
    override func main() {
        if self.delete {
            do {
                let realm = try Realm(configuration: config)
                let oldData = realm.objects(Element.self)
                realm.beginWrite()
                realm.delete(oldData)
                try realm.commitWrite()
            } catch {
                print(error)
            }
        }
        do {
            let realm = try Realm(configuration: config)
            realm.beginWrite()
            realm.add(parseData, update: true)
            try realm.commitWrite()
        } catch {
            print(error)
        }
        
    }
}

