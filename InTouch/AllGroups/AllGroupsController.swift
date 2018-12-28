//
//  AllGroupsController.swift
//  Weather
//
//  Created by Tatiana Tsygankova on 11.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit
import Kingfisher

class AllGroupsController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var groups = [Group]()
    
    var filteredGroups = [Group]()
    
    @objc func hideKeyboard() {
        tableView?.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            loadGroups()
            filteredGroups = groups
        } else {
            loadGroups(searchText)
            filteredGroups = groups.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            NetworkingService().loadGroups(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    func loadGroups(_ query: String = "математика") {
        
        NetworkingService().loadGroups(query, completionHandler: { [weak self]
            groups, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let list = groups, let self = self else { return }
            
            self.groups = list
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGroups();
        
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
        if filteredGroups.count > 0 {
            return filteredGroups.count
        } else {
            return groups.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! AllGroupsCell
        
        let group: Group
        
        if filteredGroups.count > 0 {
            group = filteredGroups[indexPath.row]
        } else {
             group = groups[indexPath.row]
        }
        
        cell.groupName.text = group.name
        cell.groupAvatar.kf.setImage(with: NetworkingService.urlForIcon(group.image))
        return cell
    }
}
