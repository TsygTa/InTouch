//
//  NewsCell.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 22.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit
import SnapKit

class NewsCell: UITableViewCell {
    
    static let offset: CGFloat = 8

    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var likesControl: LikeControl!
    @IBOutlet weak var commentsControl: ImgBtnLabelControl!
    @IBOutlet weak var repostControl: ImgBtnLabelControl!
    @IBOutlet weak var viewsControl: ImgBtnLabelControl!

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    
    private var postPhoto = UIImageView()
    private var photoScaledHeight: CGFloat = 0
    
    private let offset: CGFloat = 8
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        contentView.addSubview(postPhoto)
        postPhoto.contentMode = .scaleAspectFill
        
        postPhoto.snp.makeConstraints { make in
            make.height.equalTo(photoScaledHeight)
        }
        
    }
    
    override func layoutSubviews() {
        postPhoto.frame = CGRect(x: offset, y: offset + headerView.frame.size.height, width: bounds.width - 2*offset, height: photoScaledHeight)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.commentsControl.setImage("comment.png")
        self.repostControl.setImage("send.png")
        self.viewsControl.setImage("show.png")
        self.viewsControl.setButtonDisabled(true)
    }
    
    public func configure(with item: Post, at indexPath: IndexPath,  by photoService: PhotoService, photoHeight photoScaledHeight: CGFloat) {
        
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
        self.photoScaledHeight = photoScaledHeight
        postPhoto.image = photoService.photo(at: indexPath, by: item.photo)
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        postHeightConstraint.constant = photoScaledHeight + 2*offset
//        postPhoto.snp.makeConstraints{ (make) -> Void in
//            make.height.equalTo(photoScaledHeight)
//        }
//    }
}
