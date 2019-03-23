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
    private var button: UIButton = UIButton(type: .custom)
    private var isLiked: Bool = false {
        didSet {
//            updateButton(false)
        }
    }
    
    private func setupView() {
        button.setImage(UIImage(named: "heart.png")!, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        let str = self.counter > 0 ? String(format:"%d", self.counter) : ""
        button.setTitle(str, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
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
            let str = self.counter > 0 ? String(format:"%d", self.counter) : ""
            UIView.transition(with: button.titleLabel!, duration: 1, options: .transitionFlipFromLeft, animations:
                {self.button.setTitle(str, for: .normal)})
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
        let str = counter > 0 ? String(format:"%d", counter) : ""
        button.setTitle(str, for: .normal)
    }
    
    public func setLiked(_ liked: Bool) {
        self.isLiked = liked
        updateButton(false)
    }
}
