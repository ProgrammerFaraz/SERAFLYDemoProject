//
//  QuickAccessCollectionViewCell.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 8/22/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import UIKit
import SDWebImage

class QuickAccessCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    var date : Date?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(title: String, distance: String, date: String) {
        titleLabel.text = title
        distanceLabel.text = distance
        self.date = Utilities.formatDate(dateString: date)
    }

}
