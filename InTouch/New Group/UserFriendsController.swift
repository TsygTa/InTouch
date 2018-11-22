//
//  UserFriendsController.swift
//  Weather
//
//  Created by Цыганкова Татьяна on 12.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit

struct Section{
    var letter: Character!
    var friends: [FriendModel]!
    
    init(_ letter: Character, _ friend: FriendModel) {
        self.letter = letter
        self.friends = [FriendModel]()
        self.friends.append(friend)
    }
}

class UserFriendsController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var friendSearchBar: UITableView!
    
    var userFriends = [
        FriendModel(name: "Татьяна", image: UIImage(named: "Tatiana.png")!, likes: 25, liked: false),
        FriendModel(name: "Ирина", image: UIImage(named: "Irina.png")!, likes: 30, liked: false),
        FriendModel(name: "Ольга", image: UIImage(named: "Olga.png")!, likes: 33, liked: false),
        FriendModel(name: "Оксана", image: UIImage(named: "Oksana.png")!, likes: 777, liked: false),
        FriendModel(name: "Анна", image: UIImage(named: "Anna.png")!, likes: 5, liked: false),
        FriendModel(name: "Иван", image: UIImage(named: "Ivan.png")!, likes: 3, liked: false),
        FriendModel(name: "Борис", image: UIImage(named: "Boris.png")!, likes: 25, liked: false),
        FriendModel(name: "Мария", image: UIImage(named: "Mariya.png")!, likes: 30, liked: false),
        FriendModel(name: "Кирилл", image: UIImage(named: "Kirill.png")!, likes: 33, liked: false),
        FriendModel(name: "Инга", image: UIImage(named: "Inga.png")!, likes: 777, liked: false),
        FriendModel(name: "Олег", image: UIImage(named: "Oleg.png")!, likes: 5, liked: false),
        FriendModel(name: "Игорь", image: UIImage(named: "Igor.png")!, likes: 3, liked: false)
    ]
    
    var friendsSections = [Section]()
    
    var filteredFriends = [FriendModel]()
    
    private func makeSections() {
        for friend in filteredFriends {
            guard !friendsSections.isEmpty  else { friendsSections.append(Section(friend.name.first!, friend)); continue}
            if friendsSections.last?.letter == friend.name.first! {
                friendsSections[friendsSections.count-1].friends.append(friend)
            } else {
                friendsSections.append(Section(friend.name.first!, friend));
            }
        }
    }
    
    func friendSearchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredFriends = userFriends
        } else {
            filteredFriends = userFriends.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        makeSections()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "UserFriendsHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderID")
        
        userFriends = userFriends.sorted{ $0.name.lowercased() < $1.name.lowercased() }
        
        filteredFriends = userFriends
        
        makeSections()
        
        friendSearchBar.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return friendsSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friendsSections[section].friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserFriendCell", for: indexPath) as! UserFriendsCell

        let friend = friendsSections[indexPath.section].friends[indexPath.row]

        cell.userFriendName.text = friend.name
        cell.userFriendAvatar.image = friend.image
        
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderID")  as! UserFriendsHeader
//        header.label.text = String(friendsSections[section].letter)
        return header
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(friendsSections[section].letter)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let friendController = segue.destination as? FriendController else { return }
        
        if let indexPath = tableView.indexPathForSelectedRow  {
            let friend = userFriends[indexPath.row]
            
            friendController.photo = friend.image
            friendController.likes = friend.likes
            friendController.liked = friend.liked
        }
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
