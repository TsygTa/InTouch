//
//  UserFriendsController.swift
//  Weather
//
//  Created by Цыганкова Татьяна on 12.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit
import Kingfisher

protocol FriendDelegate {
    func onSwipeFriendsPhoto (direction: Any?) -> User?
    func onLikedChange (_ likes: Int, _ liked: Bool)
}

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

class UserFriendsController: UITableViewController, UISearchBarDelegate,  FriendDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var userFriends = [User]()
    
    var friendsSections = [Section]()
    
    var filteredFriends = [User]()
    
    var selectedSection = 0
    var selectedRow = 0
    var selectedFriendId = 0
    
    func onSwipeFriendsPhoto(direction: Any?) -> User? {
        
        guard let dir = direction as? Direction else {return nil}
        
        switch dir {
        case .left:
            if friendsSections[selectedSection].friends.count-1 > selectedRow {
                selectedRow += 1
            } else if friendsSections.count-1 > selectedSection {
                selectedSection += 1
                selectedRow = 0
            }
        case .right:
            if selectedRow > 0 {
                selectedRow -= 1
            } else if selectedSection > 0 {
                selectedSection -= 1
                selectedRow = friendsSections[selectedSection].friends.count - 1
            }
        }
        selectedFriendId = friendsSections[selectedSection].friends[selectedRow].id
        return friendsSections[selectedSection].friends[selectedRow]
    }
    
    func onLikedChange(_ likes: Int, _ liked: Bool) {
        var index = 0
        for friend in userFriends {
            if friend.id == selectedFriendId {
                userFriends[index].likes = likes
                userFriends[index].liked = liked
                break
            }
            index += 1
        }
        index = 0
        for friend in filteredFriends {
            if friend.id == selectedFriendId {
                filteredFriends[index].likes = likes
                filteredFriends[index].liked = liked
                break
            }
            index += 1
        }
        makeSections()
    }
    
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
        
        NetworkingService().loadUserFriends(completionHandler: { [weak self]
            friends, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let users = friends, let self = self else { return }
            
            self.userFriends = users
            
            DispatchQueue.main.async {
                self.userFriends = self.userFriends.sorted{ $0.name.lowercased() < $1.name.lowercased() }
                self.filteredFriends = self.userFriends
                self.makeSections()
                self.tableView.reloadData()
            }
            
        })

        tableView.register(UINib(nibName: "UserFriendsHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderID")
        
        searchBar.delegate = self
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        hideKeyboardGesture.cancelsTouchesInView = false
        tableView?.addGestureRecognizer(hideKeyboardGesture)
        
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
//        header.label.text = String(friendsSections[section].letter)
        return header
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(friendsSections[section].letter)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let friendController = segue.destination as? FriendController else { return }
        
        if let indexPath = tableView.indexPathForSelectedRow  {
            let friend = friendsSections[indexPath.section].friends[indexPath.row]
            friendController.delegate = self
            friendController.friend = friend
            selectedSection = indexPath.section
            selectedRow = indexPath.row
            selectedFriendId = friend.id
        }
    }
}
