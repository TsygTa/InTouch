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
    
    @IBOutlet weak var postText: UILabel!
    
    @IBOutlet weak var postPhoto: UIImageView!

    @IBOutlet weak var likesControl: LikeControl!

    @IBOutlet weak var commentsControl: ImgBtnLabelControl!
    
    @IBOutlet weak var repostControl: ImgBtnLabelControl!

    @IBOutlet weak var viewsControl: ImgBtnLabelControl!
    
    @IBOutlet weak var photoHeightConstraint: NSLayoutConstraint!
    
    
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with item: Post) {
        
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
        
        self.postPhoto.image = nil
        self.photoHeightConstraint.constant = 0
        
        setImage(withUrlString: item.photo)
        
    }
    
    private func setImage(withUrlString urlString: String) {
        
        self.postPhoto.image = nil
        self.photoHeightConstraint.constant = 0
        
        guard let url = URL(string: urlString) else { return }
       
        self.postPhoto.kf.setImage(with: url) { result in
            switch result {
            case .success(let value):
                self.adjustHeightToFitImage(image: value.image)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func adjustHeightToFitImage(image: UIImage?) {
        
        guard let image = image else {return}

        let aspectRatio = image.size.height / image.size.width
        let photoHeightToFit = self.frame.size.width * aspectRatio

        if self.photoHeightConstraint.constant != photoHeightToFit {
            self.photoHeightConstraint.constant = photoHeightToFit
        }
    }
}
