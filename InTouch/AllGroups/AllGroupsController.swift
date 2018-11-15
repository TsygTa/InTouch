//
//  AllGroupsController.swift
//  Weather
//
//  Created by Tatiana Tsygankova on 11.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit

class AllGroupsController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var groups = [
            DataModel(name: "Физика", image: UIImage(named: "gr_1.png")!),
            DataModel(name: "Биология", image: UIImage(named: "gr_2.png")!),
            DataModel(name: "Математика", image: UIImage(named: "gr_3.png")!),
            DataModel(name: "IT", image: UIImage(named: "gr_4.png")!),
            DataModel(name: "Книги", image: UIImage(named: "gr_5.png")!),
            DataModel(name: "Кино", image: UIImage(named: "gr_6.png")!),
            DataModel(name: "Путешествия", image: UIImage(named: "gr_7.png")!),
            DataModel(name: "Авто", image: UIImage(named: "avto.png")!),
            DataModel(name: "Интерьер", image: UIImage(named: "inter.png")!),
            DataModel(name: "Рестораны", image: UIImage(named: "restor.png")!),
            DataModel(name: "Медицина", image: UIImage(named: "med.png")!),
            DataModel(name: "Мода", image: UIImage(named: "moda.png")!),
            DataModel(name: "Образование", image: UIImage(named: "education.png")!),
            DataModel(name: "Домашние животные", image: UIImage(named: "pets.png")!),
            DataModel(name: "Природа", image: UIImage(named: "nature.png")!)
        ]
    
    var filteredGroups = [DataModel]()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredGroups = groups
        } else {
            filteredGroups = groups.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
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
        if filteredGroups.count > 0 {
            return filteredGroups.count
        } else {
            return groups.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! AllGroupsCell
        
        let group: DataModel
        
        if filteredGroups.count > 0 {
            group = filteredGroups[indexPath.row]
        } else {
             group = groups[indexPath.row]
        }
        
        cell.groupName.text = group.name
        cell.groupAvatar.image = group.image
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
