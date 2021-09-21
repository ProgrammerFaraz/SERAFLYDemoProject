//
//  NewTemplateTableViewCell.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 9/21/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import UIKit

class NewTemplateTableViewCell: UITableViewCell {

    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(image: UIImage, title: String, subTitle: String) {
        self.titleImageView.image = image
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
    }
}
