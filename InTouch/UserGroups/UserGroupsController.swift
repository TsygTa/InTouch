//
//  UserGroupsController.swift
//  Weather
//
//  Created by Tatiana Tsygankova on 11.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit

class UserGroupsController: UITableViewController {
    
    var userGroups = [DataModel]()
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        guard segue.identifier == "addGroup" else { return }
        
        let allGroupsController = segue.source as! AllGroupsController
        
        if let indexPath = allGroupsController.tableView.indexPathForSelectedRow  {
            
            var group: DataModel
            
            if allGroupsController.filteredGroups.count > 0 {
                group = allGroupsController.filteredGroups[indexPath.row]
            } else {
                group = allGroupsController.groups[indexPath.row]
            }
            
            let newGroup = DataModel(name: group.name, image: group.image)
            
            for userGroup in userGroups {
                if userGroup.name == newGroup.name {
                    return
                }
            }
            
            userGroups.append(newGroup)
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        cell.userGroupAvatar.image = group.image

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            userGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
