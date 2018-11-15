//
//  UserGroupsCell.swift
//  Weather
//
//  Created by Tatiana Tsygankova on 11.11.2018.
//  Copyright © 2018 Tatiana Tsygankova. All rights reserved.
//

import UIKit

class UserGroupsCell: UITableViewCell {

    @IBOutlet weak var userGroupName: UILabel!
    @IBOutlet weak var userGroupAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
