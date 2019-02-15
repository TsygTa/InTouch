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
    
    @IBOutlet weak var postPhoto: UIImageView!
    
    @IBOutlet weak var likesControl: LikeControl!
    
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var commentLable: UILabel!
    
    @IBOutlet weak var repostButton: UIButton!
    
    @IBOutlet weak var repostLable: UILabel!
    
    @IBOutlet weak var viewsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with item: Post) {
        self.postText.text = item.post
        self.postPhoto.kf.setImage(with: NetworkingService.urlForIcon(item.photo))
        self.likesControl.setCounter(item.likes)
        self.viewsLabel.text = item.views == 0 ? "" : String(format:"%d", item.views)
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
        self.commentLable.text = item.comments == 0 ? "" : String(format: "%d", item.comments)
        self.repostLable.text = item.reposts == 0 ? "" : String(format: "%d", item.reposts)
    }
}
