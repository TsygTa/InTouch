//
//  UserFriendsController.swift
//  Weather
//
//  Created by Цыганкова Татьяна on 12.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit

protocol FriendDelegate {
    func onSwipeFriendsPhoto (direction: Any?) -> FriendModel?
    func onLikedChange (_ likes: Int, _ liked: Bool)
}

enum Direction {
    case left
    case right
}

struct Section {
    var letter: Character!
    var friends: [FriendModel]!
    
    init(_ letter: Character, _ friend: FriendModel) {
        self.letter = letter
        self.friends = [FriendModel]()
        self.friends.append(friend)
    }
}

class UserFriendsController: UITableViewController, UISearchBarDelegate,  FriendDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var userFriends = [
        FriendModel(id: 0, name: "Татьяна", image: UIImage(named: "Tatiana.png")!, likes: 255, liked: false),
        FriendModel(id: 1, name: "Ирина", image: UIImage(named: "Irina.png")!, likes: 302, liked: false),
        FriendModel(id: 2, name: "Ольга", image: UIImage(named: "Olga.png")!, likes: 333, liked: false),
        FriendModel(id: 3, name: "Оксана", image: UIImage(named: "Oksana.png")!, likes: 777, liked: false),
        FriendModel(id: 4, name: "Анна", image: UIImage(named: "Anna.png")!, likes: 555, liked: false),
        FriendModel(id: 5, name: "Иван", image: UIImage(named: "Ivan.png")!, likes: 377, liked: false),
        FriendModel(id: 6, name: "Борис", image: UIImage(named: "Boris.png")!, likes: 254, liked: false),
        FriendModel(id: 7, name: "Мария", image: UIImage(named: "Mariya.png")!, likes: 301, liked: false),
        FriendModel(id: 8, name: "Кирилл", image: UIImage(named: "Kirill.png")!, likes: 335, liked: false),
        FriendModel(id: 9, name: "Инга", image: UIImage(named: "Inga.png")!, likes: 777, liked: false),
        FriendModel(id: 10, name: "Олег", image: UIImage(named: "Oleg.png")!, likes: 567, liked: false),
        FriendModel(id: 11, name: "Игорь", image: UIImage(named: "Igor.png")!, likes: 398, liked: false)
    ]
    
    var friendsSections = [Section]()
    
    var filteredFriends = [FriendModel]()
    
    var selectedSection = 0
    var selectedRow = 0
    var selectedFriendId = 0
    
    func onSwipeFriendsPhoto(direction: Any?) -> FriendModel? {
        
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

        tableView.register(UINib(nibName: "UserFriendsHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderID")
        
        userFriends = userFriends.sorted{ $0.name.lowercased() < $1.name.lowercased() }
        
        filteredFriends = userFriends
        
        makeSections()
        
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
            let friend = friendsSections[indexPath.section].friends[indexPath.row]
            friendController.delegate = self
            friendController.friend = friend
            selectedSection = indexPath.section
            selectedRow = indexPath.row
            selectedFriendId = friend.id
        }
    }
}
