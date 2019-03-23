//
//  NewsController.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 22.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit
import RealmSwift
import SnapKit

class NewsController: UITableViewController {
    
    private var groups = [Group]()
    private var users = [User]()
    
    private var posts = [Post]()
    private var photoHeights = [IndexPath: CGFloat]()
    private var textHeights = [IndexPath: CGFloat]()
    private var maxSize = CGSize()
    
    private var currentPeriod = 0
    private var total = 100
    private var isLoadInProgress = false
    
    private var operationQueue = OperationQueue()
    private var photoService: PhotoService?
    
    private var indicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NewsCellFramedLayout.self, forCellReuseIdentifier: NewsCellFramedLayout.reuseId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.prefetchDataSource = self
        
        tableView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        })
        indicatorView.startAnimating()
        
        photoService = PhotoService(container: self.tableView)
 //       configureRefreshControl()
        tableView.isHidden = true
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
    
    private func loadNews() {
        
        guard !isLoadInProgress else { return }
        
        isLoadInProgress = true
        let getDataOperation = GetDataOperation(type: Post.self)
        
        let parseUserData = ParseData<User>(item: "profiles")
        let parseGroupData = ParseData<Group>(item: "groups")
        let parsePostData = ParseData<Post>(item: "items")
        
        let saveUserToRealm = SaveDataToRealm<User>()
        let saveGrouptToRealm = SaveDataToRealm<Group>()
        let reloadPostController = ReloadTableController(controller: self, refreshController: self.refreshControl, completion: nil)
        
        parseUserData.addDependency(getDataOperation)
        parseGroupData.addDependency(getDataOperation)
        parsePostData.addDependency(getDataOperation)
        
        parsePostData.completionBlock = { [] in
           
            let newPosts = parsePostData.outputData
            let lastIndex = self.posts.count
            
            self.currentPeriod += 1
            self.posts.append(contentsOf: newPosts)
            
            for (index, post) in newPosts.enumerated() {
                self.photoService?.fetch(byUrl: post.photo)
                let indexPath = IndexPath(item: lastIndex + index, section: 0)
                
                var textHeight: CGFloat = 0
                let boundsRect = post.post.boundingRect(with: self.maxSize,
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                      context: nil)
                textHeight = boundsRect.height.rounded(FloatingPointRoundingRule.up)
                
                var photoHeight: CGFloat = 0
                if post.photoWidth != 0 {
                    photoHeight = CGFloat(post.photoHeight)/CGFloat(post.photoWidth) * self.maxSize.width
                }
                DispatchQueue.main.async {
                    self.textHeights[indexPath] = textHeight
                    self.photoHeights[indexPath] = photoHeight
                }
            }
            let newIndexPaths = self.calculateIndexPathsToReload(from: newPosts)
            self.isLoadInProgress = false
            if self.currentPeriod > 1 {
                DispatchQueue.main.async {
                    let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: newIndexPaths)
                    self.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
                    self.tableView.scrollToNearestSelectedRow(at: .top, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    self.indicatorView.stopAnimating()
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
        }
        saveUserToRealm.addDependency(parseUserData)
        saveGrouptToRealm.addDependency(parseGroupData)
        reloadPostController.addDependency(parsePostData)
        
        operationQueue.addOperations([getDataOperation,parseUserData, parseGroupData, parsePostData], waitUntilFinished: true)
        OperationQueue.main.addOperations([saveUserToRealm,saveGrouptToRealm], waitUntilFinished: false)
        OperationQueue.main.addOperation(reloadPostController)
    }
    
    private func calculateIndexPathsToReload(from newPosts: [Post]) -> [IndexPath] {
        let startIndex = posts.count - newPosts.count
        let endIndex = startIndex + newPosts.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        maxSize = CGSize(width: tableView.bounds.width - 2*NewsCell.offset, height: CGFloat.greatestFiniteMagnitude)
        self.loadNews()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.total
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCellFramedLayout.reuseId, for: indexPath) as? NewsCellFramedLayout else {
            return UITableViewCell()
        }
        
        if isLoadingCell(for: indexPath) {
            cell.configure(with: nil)
        } else {
            let post = posts[indexPath.row]
            let textHeight = textHeights[indexPath] ?? 0
            let photoHeight = photoHeights[indexPath] ?? 0
            cell.configure(with: post, at: indexPath, by: photoService!, textHeight: textHeight, photoHeight: photoHeight)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let textHeight = textHeights[indexPath] ?? 0
        let photoHeight = photoHeights[indexPath] ?? 0
        return 6*NewsCellFramedLayout.offset + NewsCellFramedLayout.authorImageHeight + textHeight + photoHeight + NewsCellFramedLayout.controlsHeight
    }
}

extension NewsController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            loadNews()
        }
    }
}

private extension NewsController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= posts.count
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
