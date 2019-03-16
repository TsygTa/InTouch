//
//  NewsCellBody.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 13.03.2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import UIKit

class NewsCellBody: UIView {
    
    static let reuseId = "NewsCellBodyId"
    
    var postViewHeight: CGFloat {
        return  self.postHeight + self.photoScaledHeight + self.offset
    }
    
    private let postText = UITextView()
    
    private let postPhoto: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.backgroundColor = .white
        return icon
    }()
    
    private let offset: CGFloat = 8
    private let defaultFont = UIFont.systemFont(ofSize: 12)
    
    private var photoWidth: CGFloat = 0
    private var photoHeight: CGFloat = 0
    
    private var postHeight: CGFloat = 0
    private var photoScaledHeight: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        postText.backgroundColor = .white
        postText.font = defaultFont
        postText.isScrollEnabled = false
        self.addSubview(postText)
        self.addSubview(postPhoto)
    }
    
    public func configure(with item: Post, at indexPath: IndexPath, by photoService: PhotoService?) {
        let attrStr = try! NSAttributedString(data: (item.post.data(using: String.Encoding.unicode, allowLossyConversion: true)!), options: [.documentType: NSAttributedString.DocumentType.html],  documentAttributes: nil)
        postText.attributedText = attrStr
        photoWidth = CGFloat(item.photoWidth)
        photoHeight = CGFloat(item.photoHeight)
        postPhoto.image = photoService?.photo(at: indexPath, by: item.photo)
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setPostTextFrame()
        setPostPhotoFrame()
        self.frame = bounds
    }
    
    private func setPostTextFrame() {
        guard !postText.text.isEmpty, let font = postText.font else { return }
        let textSize = getTextSize(text: postText.text, font: font)
        self.postHeight = textSize.height
        let textOrigin = CGPoint(x: self.frame.origin.x + self.offset,
                                 y: self.frame.origin.y)
        
        postText.frame = CGRect(origin: textOrigin, size: textSize)
    }
    
    private func setPostPhotoFrame() {
        guard photoWidth > 0 else {return}
        let scaledWidth = self.frame.size.width
        let ratio = scaledWidth / photoWidth
        self.photoScaledHeight = (photoHeight * ratio).rounded(.up)
        
        let imageSize = CGSize(width: scaledWidth, height: self.photoScaledHeight)
        
        let iconOrigin = CGPoint(x: self.frame.origin.x + self.offset,
                                 y: self.frame.origin.y + self.postHeight + self.offset)
        
        postPhoto.frame = CGRect(origin: iconOrigin, size: imageSize)
    }
    
    private func getTextSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = self.frame.width - 2 * offset
        let textblock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let rect = text.boundingRect(with: textblock,
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font : font],
                                     context: nil)
        
        let width = rect.size.width.rounded(.up)
        let height = rect.size.height.rounded(.up)
        
        return CGSize(width: width, height: height)
    }
}
