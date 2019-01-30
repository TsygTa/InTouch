//
//  AllGroupsController.swift
//  Weather
//
//  Created by Tatiana Tsygankova on 11.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class AllGroupsController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private(set) var groups: Results<Group>? = DatabaseService.getData(type: Group.self)?.filter("isMember = 0")
    
    private var notificationToken: NotificationToken?
    
    @objc func hideKeyboard() {
        tableView?.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty, let list = self.groups else {
            return
        }
        
        Group.forUser = false
        Group.query = searchText
        
        NetworkingService().fetch(completion: { [weak self]
            (groups: [Group]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard var list = groups, let self = self else { return }
            
            if let first = list.first {
                if first.id == 0 {
                    list.remove(at: 0)
                }
            }
            DatabaseService.deleteData(type: Group.self)
            DatabaseService.saveData(data: list.filter{!$0.name.lowercased().contains("deleted")})
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = groups?.observe{ [weak self] changes in
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
        
        searchBar.delegate = self
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        hideKeyboardGesture.cancelsTouchesInView = false
        tableView?.addGestureRecognizer(hideKeyboardGesture)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? AllGroupsCell, let group = groups?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.groupName.text = group.name
        cell.groupAvatar.kf.setImage(with: NetworkingService.urlForIcon(group.image))
        return cell
    }
}
