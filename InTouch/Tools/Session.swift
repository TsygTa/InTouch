//
//  Session.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 16.12.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit

class Session {
    
    private init() {}
    
    public static let instance = Session()
    
    var token = ""
    var userId = 0
}
