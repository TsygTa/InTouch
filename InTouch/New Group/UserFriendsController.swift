//
//  UserFriendsController.swift
//  Weather
//
//  Created by Цыганкова Татьяна on 12.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit

struct Header{
    var letter: Character
    var number: Int
    
    init(_ letter: Character, _ number: Int) {
        self.letter = letter
        self.number = number
    }
}

class UserFriendsController: UITableViewController {
    
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
    
    var headers = [Header]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "UserFriendsHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderID")
        
        userFriends = userFriends.sorted{ $0.name.lowercased() < $1.name.lowercased() }
        
        for friend in userFriends {
            guard !headers.isEmpty  else { headers.append(Header(friend.name.first!, 1)); continue}
            if !headers.contains{ $0.letter == friend.name.first!} {
                headers.append(Header(friend.name.first!, 1))
            } else {
                headers[headers.count-1].number += 1
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return headers.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return headers[section].number
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserFriendCell", for: indexPath) as! UserFriendsCell

        let friendName = userFriends[indexPath.row]

        cell.userFriendName.text = friendName.name
        cell.userFriendAvatar.image = friendName.image
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderID")  as! UserFriendsHeader
        header.label.text = String(headers[section].letter)
        return header
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
