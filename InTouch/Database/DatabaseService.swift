//
//  DatabaseService.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 15.01.2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import RealmSwift

class DatabaseService {
    
    func saveData<Element: Object>(data: [Element], config: Realm.Configuration = Realm.Configuration.defaultConfiguration) {
        do {
            print(config.fileURL ?? "")
            let realm = try Realm(configuration: config)
            let oldData = realm.objects(Element.self)
            
            realm.beginWrite()
            realm.delete(oldData)
            realm.add(data)
            
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}

