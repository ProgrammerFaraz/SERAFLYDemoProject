//
//  SideMenuTableViewCell.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 9/5/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(image: UIImage?, title: String) {
        if let image = image {
            titleImageView.image = image
        }
        titleLabel.text = title
    }

}
