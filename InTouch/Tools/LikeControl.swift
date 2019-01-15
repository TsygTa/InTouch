//
//  LikeControl.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 15.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit

class LikeControl: UIControl{
    
    var delegate: FriendDelegate?
    
    private var counter: Int = 0
    private var button: UIButton = UIButton()
    private var isLiked: Bool = false {
        didSet {
//            updateButton(false)
        }
    }
    
    private func setupView() {
        button = UIButton(type: .system)
        button.setImage(UIImage(named: "heart.png")!, for: .normal)
        button.setTitle(String(format:"%d", counter), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(addLike(_:)), for: .touchUpInside)
        self.addSubview(button)
    }
    
    private func updateButton(_ animate: Bool) {
        if isLiked {
            button.setImage(UIImage(named: "redheart.png")!, for: .normal)
            button.setTitleColor(UIColor.red, for: .normal)
            button.tintColor = UIColor.red
        } else {
            button.setImage(UIImage(named: "heart.png")!, for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.tintColor = UIColor.black
        }
        if animate {
            UIView.transition(with: button.titleLabel!, duration: 1, options: .transitionFlipFromLeft, animations: {self.button.setTitle(String(format:"%d", self.counter), for: .normal)})
        }
        self.layoutSubviews()
    }
    
    @objc private func addLike(_ sender: UIButton) {
        if isLiked {
            counter -= 1
            isLiked = false
        } else {
            counter += 1
            isLiked = true
        }
        updateButton(true)
        guard let userFriendsController = delegate else {return}
        userFriendsController.onLikedChange(self.counter, self.isLiked)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = bounds
    }
    
    public func getCounter() -> Int {
        return self.counter
    }
    
    public func setCounter(_ counter: Int) {
        self.counter = counter
        button.setTitle(String(format:"%d", counter), for: .normal)
    }
    
    public func setLiked(_ liked: Bool) {
        self.isLiked = liked
        updateButton(false)
    }
}
