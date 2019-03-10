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
    private var userPhotos: Results<Photo>?
    private var notificationToken: NotificationToken?
    private let networkingService = NetworkingService()
    
    private var photoIndex = -1
    
    private var animator: UIViewPropertyAnimator!
    
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
        
        guard let userPhotos = self.userPhotos else {return}
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
    
    func onLikedChange(_ likes: Int, _ liked: Bool) {
        guard let photo = self.userPhotos?[photoIndex] else {return}
        
        let newPhoto = Photo(id: photo.id, userId: photo.userId, image: photo.image, likes: likes, liked: liked)
        
        DatabaseService.saveData(data: [newPhoto])
        
        networkingService.pushLikeRequest(action: liked ? .add : .delete, ownerId: friend.id, itemId: photo.id, itemType: "photo", completion: { [weak self] (counter: Int?, error: Error?) -> Void in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
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
        guard self.friend.id > 0 else {return}
        
        Photo.userIdParameter = self.friend.id
//        networkingService.fetch(completion: { [weak self]
//            (photos: [Photo]?, error: Error?) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            guard let list = photos, let self = self else { return }
//            if list.count > 0 {
//                self.photoIndex = 0
//            }
//
//            DatabaseService.saveData(data: list)
//        })
        
        GetParseSaveOperation<Photo>.getParseSave(completion: { [weak self]
            (parseData: ParseData?, saveData: SaveDataToRealm?) in
            guard let parse = parseData, let save = saveData else {return}
            if parse.outputData.count > 0 {
                self?.photoIndex = 0
            }
            save.parseData = parse.outputData
        })
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.userPhotos = DatabaseService.getData(type: Photo.self)?.filter("userId = %@", self.friend.id)
        
        if self.userPhotos!.count > 0 {
            self.photoIndex = 0
        }

        self.notificationToken = userPhotos?.observe{ [weak self] changes in
            guard let self = self else {return}

            switch changes {
            case .initial(_), .update(_, _, _, _):
                self.collectionView.reloadData()
            case .error(let error):
                self.showAlert(error: error)
            }
        }
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
        
        return self.userPhotos?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCellID", for: indexPath) as! FriendCell
        
        if self.photoIndex >= 0,
            let photo = userPhotos?[self.photoIndex]  {
                cell.configure(with: photo, delegate: self)
        }

        return cell
    }

}
