//
//  UserGroupsController.swift
//  Weather
//
//  Created by Tatiana Tsygankova on 11.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit
import RealmSwift

class UserGroupsController: UITableViewController {
    
    var userGroups: Results<Group>? = DatabaseService.getData(type: Group.self)?.filter("isMember = 1")
    
    var notificationToken: NotificationToken?
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        guard segue.identifier == "addGroup" else { return }
        
        let allGroupsController = segue.source as! AllGroupsController
        
        if let indexPath = allGroupsController.tableView.indexPathForSelectedRow  {
            
            guard let groups = allGroupsController.groups else {return}
            
            let group: Group = groups[indexPath.row]
            
            let newGroup = Group(id: group.id, name: group.name, image: group.image, is_member: 1)
            
            do {
                try DatabaseService.saveData(data: [newGroup])
            } catch {
                self.showAlert(error: error)
            }
            
            NetworkingService().groupJoinRequest(groupId: group.id, completion: { [weak self] (result: Int?, error: Error?) -> Void in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        notificationToken = userGroups?.observe{ [weak self] changes in
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
//            DatabaseService.deleteData(type: Group.self)
            DatabaseService.saveData(data: list)
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userGroups?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserGroupCell", for: indexPath) as? UserGroupsCell, let group = userGroups?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.userGroupName.text = group.name
        cell.userGroupAvatar.kf.setImage(with: NetworkingService.urlForIcon(group.image))

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            guard let group = userGroups?[indexPath.row] else { return }
            try? DatabaseService.delete([group])
        }
    }
}
