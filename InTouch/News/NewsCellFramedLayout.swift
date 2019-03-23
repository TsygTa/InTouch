//
//  NewsCellFramedLayout.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 18.03.2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import UIKit
import SnapKit

class NewsCellFramedLayout: UITableViewCell {
    
    static let reuseId = "NewsCellFramedLayoutId"
    static let offset: CGFloat = 8
    static let authorImageHeight: CGFloat = 64
    static let controlsHeight: CGFloat = 28
    
    private var authorImage = UIImageView()
    private var authorLabel = UILabel()
    private var dateLabel = UILabel()
    
    private var postPhoto = UIImageView()
    private var photoScaledHeight: CGFloat = 0
    private var postText = UILabel()
    private var postTextHeight: CGFloat = 0
    
    private var likesControl = ImgBtnLabelControl()
    private var commentsControl = ImgBtnLabelControl()
    private var repostsControl = ImgBtnLabelControl()
    private var viewsControl = ImgBtnLabelControl()
    private var indicatorView = UIActivityIndicatorView()
    
    private let offset: CGFloat = 8
    private let authorImageHeight: CGFloat = 64
    private let rowLabelHeight: CGFloat = 28
    private let controlsHeight: CGFloat = 28
    private let controlsWidth: CGFloat = 80
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(authorImage)
        authorImage.contentMode = .scaleAspectFill
        authorImage.layer.cornerRadius = authorImageHeight / 2
        authorImage.layer.masksToBounds = true
        
        contentView.addSubview(authorLabel)
        authorLabel.font = UIFont.systemFont(ofSize: 14)
        
        contentView.addSubview(dateLabel)
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        
        contentView.addSubview(postText)
        postText.numberOfLines = 0
        
        contentView.addSubview(postPhoto)
        postPhoto.contentMode = .scaleAspectFill
        
        contentView.addSubview(likesControl)
        contentView.addSubview(commentsControl)
        contentView.addSubview(repostsControl)
        contentView.addSubview(viewsControl)
        
        commentsControl.setImage("comment.png")
        commentsControl.setButtonDisabled(true)
        repostsControl.setImage("send.png")
        repostsControl.setButtonDisabled(true)
        viewsControl.setImage("show.png")
        viewsControl.setButtonDisabled(true)
        likesControl.setImage("heart.png")
        
        contentView.addSubview(indicatorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        authorImage.frame = CGRect(x: offset,
                                   y: offset,
                                   width: authorImageHeight,
                                   height: authorImageHeight)
        
        authorLabel.frame = CGRect(x: offset + authorImageHeight + offset,
                                   y: offset,
                                   width: bounds.width - (offset + authorImageHeight + offset),
                                   height: rowLabelHeight)
        
        dateLabel.frame = CGRect(x: offset + authorImageHeight + offset,
                                 y: offset + rowLabelHeight + offset,
                                 width: bounds.width - (offset + authorImageHeight + offset),
                                 height: rowLabelHeight)
        
        postText.frame = CGRect(x: offset,
                                 y: offset + authorImageHeight + offset,
                                 width: bounds.width - 2*offset,
                                 height: postTextHeight)
        
        postPhoto.frame = CGRect(x: offset,
                                 y: 3*offset + authorImageHeight + postTextHeight,
                                 width: bounds.width - 2*offset,
                                 height: photoScaledHeight)
        let controlsY = 4*offset + authorImageHeight + postTextHeight + photoScaledHeight
        likesControl.frame = CGRect(x: offset,
                                    y: controlsY,
                                    width: controlsWidth,
                                    height: controlsHeight)
        commentsControl.frame = CGRect(x: 2*offset + controlsWidth,
                                    y: controlsY,
                                    width: controlsWidth,
                                    height: controlsHeight)
        repostsControl.frame = CGRect(x: 3*offset + 2*controlsWidth,
                                       y: controlsY,
                                       width: controlsWidth,
                                       height: controlsHeight)
        viewsControl.frame = CGRect(x: 4*offset + 3*controlsWidth,
                                      y: controlsY,
                                      width: controlsWidth,
                                      height: controlsHeight)
        
        indicatorView.frame = CGRect(x: bounds.width/2 - 16,
                                    y: bounds.height/2 - 16,
                                    width: 32,
                                    height: 32)
    }
    
    public func configure(with item: Post?, at indexPath: IndexPath? = nil,  by photoService: PhotoService? = nil, textHeight postTextHeight: CGFloat = CGFloat(0), photoHeight photoScaledHeight: CGFloat = CGFloat(0)) {
        
        guard let item = item, let indexPath = indexPath else {
            self.layer.borderColor = UIColor.white.cgColor
            self.layer.borderWidth = 0
            indicatorView.startAnimating()
            return
        }
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        self.dateLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: item.date))
        
        if item.authorId < 0, let group = item.group {
            self.authorLabel.text = group.name
            self.authorImage.kf.setImage(with: NetworkingService.urlForIcon(group.image))
        } else if item.authorId > 0, let user = item.user {
            self.authorLabel.text = user.name
            self.authorImage.kf.setImage(with: NetworkingService.urlForIcon(user.image))
        } else {
            self.authorLabel.text = ""
            self.authorImage.image = UIImage(contentsOfFile: "emptyImage.png")
        }
        likesControl.setCounter(item.likes)
        commentsControl.setCounter(item.comments)
        repostsControl.setCounter(item.reposts)

        if item.type == "photo" {
            viewsControl.isHidden = true
        } else {
            viewsControl.isHidden = false
            viewsControl.setCounter(item.views)
        }
        
        postText.attributedText = NewsCellFramedLayout.getAttributedString(text: item.post)
        self.postTextHeight = postTextHeight

        self.photoScaledHeight = photoScaledHeight
        postPhoto.image = photoService?.photo(at: indexPath, by: item.photo)
        
        indicatorView.stopAnimating()
    }
    
    static func getAttributedString(text: String) -> NSAttributedString? {
        guard let data = text.data(using: .unicode, allowLossyConversion: true),
                let attrStr = try? NSAttributedString(data: data,
                                                 options: [.documentType: NSAttributedString.DocumentType.html],
                                                 documentAttributes: nil) else { return nil }
        return attrStr
    }
}
