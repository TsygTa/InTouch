//
//  FirebaseUser.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 27.01.2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import Foundation
import Firebase

class FirebaseUser {
    
    let id: Int
    var groups: [Int]? = nil
    let ref: DatabaseReference?
    
    init(id: Int, groups: [Int] = []) {
        self.id = id
        self.groups = groups
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
            let id = value["id"] as? Int else { return nil }
        
        self.id = id
        if let groups = value["groups"] as? [Int] {
            for group in groups {
                self.groups?.append(group)
            }
        }
        
        self.ref = snapshot.ref
    }
    
    func addGroup(id: Int) {
        self.groups?.append(id)
    }
    
    func toAnyObject() -> [String: Any] {
        return [
            "id": id,
            "groups": groups as Any
        ]
    }
}
