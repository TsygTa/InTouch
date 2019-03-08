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
    
//    private let networkingService = NetworkingService()
    private var groups = [Group]()
    private var users = [User]()
    
    private var posts = [Post]()
    private var lastRow: Int = 0
    
    private var operationQueue = OperationQueue()
    private var photoService: PhotoService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 338
        
        photoService = PhotoService(container: self.tableView)
        configureRefreshControl()
    }
    
    private func configureRefreshControl() {
        
        let rC = UIRefreshControl()
        rC.tintColor = UIColor.green
        rC.attributedTitle = NSAttributedString(string: "Загрузка новостей...")
        rC.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        
        tableView.refreshControl = rC
    }
    
    @objc func refreshNews() {
        guard let rC = refreshControl else { return }
        rC.beginRefreshing()
        self.loadNews()
    }
    
    private func loadNews(completion: (() -> Void)? = nil) {
//        networkingService.fetch(completion: { [weak self] (posts: [Post]?, groups: [Group]?, users: [User]?, error: Error?) in
//
//            DispatchQueue.main.async {
//                if let error = error {
//                    print(error.localizedDescription)
//                    return
//                }
//                guard let listP = posts, let listG = groups, let listU = users, let self = self else { return }
//
//                DatabaseService.saveData(data: listG)
//                DatabaseService.saveData(data: listU)
//
//                self.posts = listP
//                self.tableView.reloadData()
//            }
//        })
        
        let getDataOperation = GetDataOperation(type: Post.self)
        
        let parseUserData = ParseData<User>(item: "profiles")
        let parseGroupData = ParseData<Group>(item: "groups")
        let parsePostData = ParseData<Post>(item: "items")
        
        let saveUserToRealm = SaveDataToRealm<User>()
        let saveGrouptToRealm = SaveDataToRealm<Group>()
        let reloadPostController = ReloadTableController(controller: self, refreshController: tableView.refreshControl, completion: completion)
        
        parseUserData.addDependency(getDataOperation)
        parseGroupData.addDependency(getDataOperation)
        parsePostData.addDependency(getDataOperation)
        
        parsePostData.completionBlock = { [unowned parsePostData, unowned reloadPostController] in
            self.posts = parsePostData.outputData        
//            self.tableView.insertRows(at: [NSIndexPath(row: self.lastRow, section: 0) as IndexPath], with: .automatic)
        }
        
        saveUserToRealm.addDependency(parseUserData)
        saveGrouptToRealm.addDependency(parseGroupData)
        reloadPostController.addDependency(parsePostData)
        
        operationQueue.addOperations([getDataOperation,parseUserData, parseGroupData, parsePostData], waitUntilFinished: true)
        OperationQueue.main.addOperations([saveUserToRealm,saveGrouptToRealm], waitUntilFinished: false)
        OperationQueue.main.addOperation(reloadPostController)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadNews()
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
        cell.configure(with: post, at: indexPath, by: photoService) { [weak self] in
            guard let self = self else { return }
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
        
//        if indexPath.row == self.posts.count - 1 {
//            Session.instance.newsDumpCounter += 1
//            self.lastRow = indexPath.row
//            if let rC = self.tableView.refreshControl {
//                rC.beginRefreshing()
//            }
//            self.loadNews() { [weak self] in
//                guard let self = self else { return }
//                self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
//            }
//        }
        return cell
    }
}
