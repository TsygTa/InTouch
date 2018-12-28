//
//  FriendController.swift
//  Weather
//
//  Created by Цыганкова Татьяна on 12.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit

//private let reuseIdentifier = "Cell"

class FriendController: UICollectionViewController {
    
    var delegate: FriendDelegate?

    var friend = User()
    
    var animator: UIViewPropertyAnimator!
    
    @IBAction func onSwipe(direction: Any?) {
        guard let userFriendsController = delegate else {return}
        guard let dir = direction as? Direction else {return}
    
        let oldFriend = self.friend
        self.friend = userFriendsController.onSwipeFriendsPhoto(direction: direction)!
        
        if oldFriend.id != self.friend.id {
            switch dir {
            case .left:
                collectionView.layer.add(swipeTransitionToLeftSide(true), forKey: nil)
            case .right:
                collectionView.layer.add(swipeTransitionToLeftSide(false), forKey: nil)
            }
            collectionView.reloadData()
        }
    }
    
    func swipeTransitionToLeftSide(_ leftSide: Bool) -> CATransition {
        let transition = CATransition()
        transition.startProgress = 0.0
        transition.endProgress = 1.0
        transition.type = CATransitionType.push
        transition.subtype = leftSide ? CATransitionSubtype.fromRight : CATransitionSubtype.fromLeft
        transition.duration = 0.3
        
        return transition
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkingService().loadFriendPhoto(Session.instance.userId)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            onSwipe(direction: Direction.right)
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.left {
            onSwipe(direction: Direction.left)
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCellID", for: indexPath) as! FriendCell
        
        // Configure the cell

        cell.friendPhoto.kf.setImage(with: NetworkingService.urlForIcon(friend.image))        
        cell.friendLikes.delegate = self.delegate
        cell.friendLikes.setCounter(friend.likes)
        cell.friendLikes.setLiked(friend.liked)
    
        return cell
    }

}
