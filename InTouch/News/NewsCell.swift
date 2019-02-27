//
//  NewsCell.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 22.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var postPhoto: ScaledImageView!
    @IBOutlet weak var likesControl: LikeControl!
    @IBOutlet weak var commentsControl: ImgBtnLabelControl!
    @IBOutlet weak var repostControl: ImgBtnLabelControl!
    @IBOutlet weak var viewsControl: ImgBtnLabelControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.commentsControl.setImage("comment.png")
        self.repostControl.setImage("send.png")
        self.viewsControl.setImage("show.png")
        self.viewsControl.setButtonDisabled(true)
        
        // Initialization code
    }
    
    public func configure(with item: Post, completion: @escaping () -> Void) {
        
        let attrStr = try! NSAttributedString(data: (item.post.data(using: String.Encoding.unicode, allowLossyConversion: true)!), options: [.documentType: NSAttributedString.DocumentType.html],  documentAttributes: nil)
        self.postText.attributedText = attrStr
        
        self.likesControl.setCounter(item.likes)
        self.viewsControl.setCounter(item.views)
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
        
        self.commentsControl.setCounter(item.comments)
        self.repostControl.setCounter(item.reposts)
        
        if item.type == "photo" {
            self.viewsControl.isHidden = true
        } else {
            self.viewsControl.isHidden = false
        }
        postPhoto.kf.setImage(with: URL(string:item.photo)) { _ in
            completion()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postPhoto.kf.cancelDownloadTask()
        postPhoto.image = nil
    }
}
