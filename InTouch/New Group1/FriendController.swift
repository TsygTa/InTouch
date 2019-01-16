//
//  FriendController.swift
//  Weather
//
//  Created by Цыганкова Татьяна on 12.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit
import RealmSwift

protocol FriendDelegate {
    func onLikedChange (_ likes: Int, _ liked: Bool)
}

class FriendController: UICollectionViewController,  FriendDelegate {
    
    var friend = User()
    var userPhotos = [Photo]()
    var photoIndex = -1
    
    var animator: UIViewPropertyAnimator!
    
    @IBAction func onSwipe(direction: Any?) {
        guard let dir = direction as? Direction else {return}
        
        setUserPhotoIndex(dir)
        
        switch dir {
        case .left:
            collectionView.layer.add(swipeTransitionToLeftSide(true), forKey: nil)
        case .right:
            collectionView.layer.add(swipeTransitionToLeftSide(false), forKey: nil)
        }
        collectionView.reloadData()
    }
    
    private func setUserPhotoIndex(_ direction: Direction) {
        guard userPhotos.count > 0 else {
            photoIndex = -1
            return
        }
        
        switch direction {
        case .left:
            if photoIndex == 0 {
                photoIndex = userPhotos.count-1
            } else {
                photoIndex -= 1
            }
        case .right:
            if photoIndex == userPhotos.count-1 {
                photoIndex = 0
            } else {
                photoIndex += 1
            }
        }
    }
    
    private func loadData(_ query: String = "") {
        let userPhotosRealm: Results<Photo>? = try? Realm().objects(Photo.self).filter("userId = \(friend.id)")
        guard let photos = userPhotosRealm else {return}
        
        self.userPhotos = Array(photos)
        self.photoIndex = 0
        self.collectionView.reloadData()
    }
    
    func onLikedChange(_ likes: Int, _ liked: Bool) {
        self.userPhotos[photoIndex].likes = likes
        self.userPhotos[photoIndex].liked = liked
        NetworkingService().pushLikeRequest(action: liked ? .add : .delete, ownerId: friend.id, itemId: userPhotos[photoIndex].id, itemType: "photo", completion: { [weak self] (counter: Int?, error: Error?) -> Void in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let number = counter, let self = self else { return }
                self.userPhotos[self.photoIndex].likes = number
        })
    }
    
    func checkIsLiked() {
        guard userPhotos.count > 0 else { return }
        NetworkingService().isLikeRequest(ownerId: friend.id, itemId: userPhotos[photoIndex].id, itemType: "photo", completion:
            { [weak self] (isLiked: Bool?, error: Error?) -> Void in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let liked = isLiked, let self = self else { return }
                self.userPhotos[self.photoIndex].liked = liked
        })
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
        Photo.userIdParameter = self.friend.id
        NetworkingService().fetch(completion: { [weak self]
            (photos: [Photo]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let list = photos, let self = self else { return }
            
            self.userPhotos = list
            self.photoIndex = 0
            
//            DatabaseService().saveData(data: list)
            
            DispatchQueue.main.async {
//                self.loadData()
                self.collectionView.reloadData()
            }
            
        })
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//    }
    
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
        if self.userPhotos.count == 0 {
            return 0
        }
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCellID", for: indexPath) as! FriendCell

        if photoIndex >= 0 {
            self.checkIsLiked()
            cell.friendPhoto.kf.setImage(with: NetworkingService.urlForIcon(self.userPhotos[photoIndex].image))
            cell.friendLikes.delegate = self
            cell.friendLikes.setCounter(self.userPhotos[photoIndex].likes)
            cell.friendLikes.setLiked(self.userPhotos[photoIndex].liked)
        }
        
        return cell
    }

}
