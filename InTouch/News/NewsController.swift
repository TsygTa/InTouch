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
    
    private var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkingService.fetch(completion: { [weak self] (posts: [Post]?, groups: [Group]?, users: [User]?, error: Error?) in
        
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let listP = posts, let listG = groups, let listU = users, let self = self else { return }

                DatabaseService.saveData(data: listG)
                DatabaseService.saveData(data: listU)

                self.posts = listP
                self.tableView.reloadData()
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCellID", for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        
        let post = posts[indexPath.row]
        cell.configure(with: post)
        return cell
    }
}
