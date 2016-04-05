//
//  ZZFeedCell.swift
//  ZZTableViewTemplateLayoutCell
//
//  Created by duzhe on 16/4/5.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

class ZZFeedCell: UITableViewCell {

    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var contentLabel:UILabel!
    @IBOutlet weak var contentImageView:UIImageView!
    @IBOutlet weak var usernameLabel:UILabel!
    @IBOutlet weak var timeLabelLabel:UILabel!
    
    var entity:ZZFeedEntity? {
        didSet{
            guard let entity = entity else { return }
            titleLabel.text = entity.title
            contentLabel.text = entity.content
            usernameLabel.text = entity.username
            titleLabel.text = entity.time
            contentImageView.image = UIImage(named: entity.imageName ?? "")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
}
