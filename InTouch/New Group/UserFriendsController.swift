//
//  UserFriendsController.swift
//  Weather
//
//  Created by Цыганкова Татьяна on 12.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

enum Direction {
    case left
    case right
}

struct Section {
    var letter: Character!
    var friends: [User]!
    
    init(_ letter: Character, _ friend: User) {
        self.letter = letter
        self.friends = [User]()
        self.friends.append(friend)
    }
}

class UserFriendsController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var userFriends = [User]()
    
    var friendsSections = [Section]()
    
    var filteredFriends = [User]()
    
    private func makeSections() {
        friendsSections.removeAll()
        for friend in filteredFriends {
            guard !friendsSections.isEmpty  else { friendsSections.append(Section(friend.name.first!, friend)); continue}
            if friendsSections.last?.letter == friend.name.first! {
                friendsSections[friendsSections.count-1].friends.append(friend)
            } else {
                friendsSections.append(Section(friend.name.first!, friend));
            }
        }
    }
    
    @objc func hideKeyboard() {
        tableView?.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadData(searchText)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkingService().fetch(completion: { [weak self]
            (friends: [User]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let friends = friends, let self = self else { return }
            DatabaseService().saveData(data: friends.filter{!$0.name.lowercased().contains("deleted")})
            
            DispatchQueue.main.async {
                self.loadData()
            }
        })

        tableView.register(UINib(nibName: "UserFriendsHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderID")
        
        searchBar.delegate = self
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        hideKeyboardGesture.cancelsTouchesInView = false
        tableView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    func loadData(_ query: String = "") {
        let userFriendsRealm: Results<User>? = try? Realm().objects(User.self).sorted(byKeyPath: "name")
        guard let users = userFriendsRealm else {return}
        
        self.userFriends = Array(users)
        
        if query.isEmpty {
            filteredFriends = self.userFriends
        } else {
            filteredFriends = self.userFriends.filter { $0.name.lowercased().contains(query.lowercased()) }
        }
        
        self.makeSections()
        self.tableView.reloadData()
    }
    
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
        cell.userFriendAvatar.kf.setImage(with: NetworkingService.urlForIcon(friend.image))
        
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderID")  as! UserFriendsHeader
        return header
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(friendsSections[section].letter)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let friendController = segue.destination as? FriendController else { return }
        
        if let indexPath = tableView.indexPathForSelectedRow  {
            let friend = friendsSections[indexPath.section].friends[indexPath.row]
            friendController.friend = friend
        }
    }
}
