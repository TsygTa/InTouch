//
//  Fetchable.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 04.01.2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol VKFetchable {
    static var path: String {get}
    static var parameters: Parameters {get}
    
    static func parseJSON(json: JSON) -> Self
}
