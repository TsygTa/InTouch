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
    
    @IBOutlet weak var repostButton: UIButton!
    
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
    
    public func configure(with item: NewsModel) {
        
        self.postText.text = item.text
        self.postPhoto.image = item.image
        self.likesControl.setCounter(item.likes)
        self.viewsLabel.text = String(format:"%d", item.views)
        self.authorImage.image = UIImage(named: "emptyImage.png")!
        self.authorLabel.text = "Author"
        self.dateLabel.text = "01.01.1970"
    }

}
