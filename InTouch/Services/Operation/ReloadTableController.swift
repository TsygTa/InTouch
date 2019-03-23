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
    private var refreshController: UIRefreshControl?
    private var completion: (() -> Void)?
    
    init(controller: UITableViewController, refreshController: UIRefreshControl?, completion: (() -> Void)? = nil) {
        self.controller = controller
        self.refreshController = refreshController
        self.completion = completion
    }
    override func main() {
//        controller.tableView.reloadData()
        if let rC = self.refreshController {
            rC.endRefreshing()
        }
        if let compl = self.completion {
            compl()
        }
    }
}
