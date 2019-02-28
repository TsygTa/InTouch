//
//  ReloadTableController.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 24.02.2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ReloadTableController: Operation {
    private var controller: UITableViewController
    
    init(controller: UITableViewController) {
        self.controller = controller
    }
    override func main() {
        controller.tableView.reloadData()
    }
}
