//
//  NewsController.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 22.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit
import RealmSwift

class NewsController: UITableViewController {
    
    private let networkingService = NetworkingService()
    private var groups = [Group]()
    private var users = [User]()
    
    private var posts: Results<Post>? = DatabaseService.getData(type: Post.self)
    private var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = posts?.observe{ [weak self] changes in
            guard let self = self else {return}
            
            switch changes {
            case .initial(_):
                self.tableView.reloadData()
            case .update(_, let dels, let ins, let mods):
                self.tableView.applyChanges(deletions: dels, insertions: ins, updates: mods)
            case .error(let error):
                self.showAlert(error: error)
            }
        }
        
        networkingService.fetch(completion: { (posts: [Post]?, groups: [Group]?, users: [User]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let listP = posts, let listG = groups, let listU = users else { return }
            
            DatabaseService.deleteData(type: Post.self)
            DatabaseService.saveData(data: listG)
            DatabaseService.saveData(data: listU)
            DatabaseService.saveData(data: listP)
            
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.posts?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCellID", for: indexPath) as? NewsCell, let post = posts?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(with: post)
        
        return cell
    }
}
