//
//  ImgBtnLabelControl.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 15.02.2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import UIKit

class ImgBtnLabelControl: UIControl {
    
    var completionHandler:(() -> Void)?
    
    private var counter: Int = 0
    private var button: UIButton = UIButton(type: .custom)
    private var isMarked: Bool = false
    private var image: String = "heart.png"
    private var markedImage: String = "redheart.png"
    
    private func setupView() {
//        button.setImage(UIImage(named: self.image)!, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isEnabled = true
        let str = self.counter > 0 ? String(format:"%d", self.counter) : ""
        button.setTitle(str, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(UIColor.black, for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(someAction(_:)), for: .touchUpInside)
        self.addSubview(button)
    }
    
    private func updateControl(_ animate: Bool) {
        if isMarked {
            button.setImage(UIImage(named: self.markedImage)!, for: .normal)
            button.setTitleColor(UIColor.blue, for: .normal)
            button.tintColor = UIColor.blue
        } else {
            button.setImage(UIImage(named: self.image)!, for: .normal)
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
    
    @objc private func someAction(_ sender: UIButton) {
        guard self.button.isEnabled else {return}
        
        if isMarked {
            counter -= 1
            isMarked = false
        } else {
            counter += 1
            isMarked = true
        }
        updateControl(true)
        completionHandler?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    public func setMarked(_ marked: Bool) {
        self.isMarked = marked
        updateControl(false)
    }
    
    public func setImage(_ image: String) {
        self.image = image
        updateControl(false)
    }
    
    public func setButtonDisabled(_ disabled: Bool) {
        self.button.isEnabled = !disabled
        updateControl(false)
    }
}
