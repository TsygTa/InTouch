//
//  LikeControl.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 15.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit

class LikeControl: UIControl {
    
    //private var image: UIImage = UIImage(named: "heart.png")!
    private var counter: UInt = 25
    private var button: UIButton = UIButton()
    private var isLiked: Bool {
        didSet {
            updateButton()
        }
    }
    
    private func setupView() {
        button = UIButton(type: .system)
        button.setImage(UIImage(named: "heart.png")!, for: .normal)
        button.setImage(UIImage(named: "redheart.png")!, for: .selected)
        button.setTitle(String(format:"%d", counter), for: .normal)
        button.setTitle(String(format:"%d", counter), for: .selected)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setTitleColor(UIColor.red, for: .selected)
        button.addTarget(self, action: #selector(addLike(_:)), for: .touchUpInside)
        self.addSubview(button)
    }
    
    private func updateButton() {
        if isLiked {
            counter += 1
        } else {
            counter -= 1
        }
        button.titleLabel?.text = String(format:"%d", counter)
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
    
}
