//
//  UserGroupsController.swift
//  Weather
//
//  Created by Tatiana Tsygankova on 11.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit

class UserGroupsController: UITableViewController {
    
    var userGroups = [Group]()
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        guard segue.identifier == "addGroup" else { return }
        
        let allGroupsController = segue.source as! AllGroupsController
        
        if let indexPath = allGroupsController.tableView.indexPathForSelectedRow  {
            
            var group: Group
            
            if allGroupsController.filteredGroups.count > 0 {
                group = allGroupsController.filteredGroups[indexPath.row]
            } else {
                group = allGroupsController.groups[indexPath.row]
            }
            
            let newGroup = Group(id: group.id, name: group.name, image: group.image)
            
            for userGroup in userGroups {
                if userGroup.id == newGroup.id {
                    return
                }
            }
            
            userGroups.append(newGroup)
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Group.forUser = true
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
            
            self.userGroups = list
            
            DispatchQueue.main.async {
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
        return userGroups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserGroupCell", for: indexPath) as! UserGroupsCell

        let group = userGroups[indexPath.row]
        
        cell.userGroupName.text = group.name
        cell.userGroupAvatar.kf.setImage(with: NetworkingService.urlForIcon(group.image))

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            userGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
