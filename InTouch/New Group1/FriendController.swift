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

    var friend = FriendModel(name: " ", image: UIImage(named: "cross.png")!, likes: 0, liked: false)
    
    var animator: UIViewPropertyAnimator!
    
    @IBAction func onSwipe(direction: Any?) {
        guard let userFriendsController = delegate else {return}
    
        self.friend = userFriendsController.onSwipeFriendsPhoto(direction: direction)!
        collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
//        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
//        
//        self.collectionView.addGestureRecognizer(recognizer)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            onSwipe(direction: Direction.right)
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.left {
            onSwipe(direction: Direction.left)
        }
    }
    
    @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            animator?.startAnimation()
            animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: {
                self.collectionView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })
        case .changed:
            let translation = recognizer.translation(in: self.view)
            animator.fractionComplete = translation.y/100
        case .ended:
            animator.stopAnimation(true)
            animator.addAnimations {
                self.collectionView.transform = .identity
            }
            animator.startAnimation()
        default:
            return
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

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
        cell.friendPhoto.image = friend.image
        cell.friendLikes.setCounter(friend.likes)
        cell.friendLikes.setLiked(friend.liked)
    
        return cell
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
