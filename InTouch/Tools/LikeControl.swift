//
//  LikeControl.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 15.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit

class LikeControl: UIControl {
    
    private var counter: Int = 25
    private var button: UIButton = UIButton()
    private var isLiked: Bool {
        didSet {
            updateButton()
        }
    }
    
    public func setupView() {
        button = UIButton(type: .system)
        button.setImage(UIImage(named: "heart.png")!, for: .normal)
        button.setTitle(String(format:"%d", counter), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(addLike(_:)), for: .touchUpInside)
        self.addSubview(button)
    }
    
    private func updateButton() {
        if isLiked {
            counter += 1
            button.setImage(UIImage(named: "redheart.png")!, for: .normal)
            button.setTitleColor(UIColor.red, for: .normal)
            button.tintColor = UIColor.red
        } else {
            counter -= 1
            button.setImage(UIImage(named: "heart.png")!, for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.tintColor = UIColor.black
        }
        button.setTitle(String(format:"%d", counter), for: .normal)
        self.layoutSubviews()
    }
    
    @objc private func addLike(_ sender: UIButton) {
        if isLiked {
            isLiked = false
        } else {
            isLiked = true
        }
    }
    
    override init(frame: CGRect) {
        isLiked = false
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        isLiked = false
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
    }
    
}
