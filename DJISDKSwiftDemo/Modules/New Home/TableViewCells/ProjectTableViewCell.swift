//
//  ProjectTableViewCell.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 9/5/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import UIKit
import DropDown

protocol ProjectsProtocol {
    func dotMenuTapped(selectedValue: String)
}

class ProjectTableViewCell: UITableViewCell {

    //MARK:- Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dropDownView: UIView!
    var delegate: ProjectsProtocol?
    var index = 0
    var selectedValue = ""
    let dropDownDataSource = ["Edit", "Delete"]
    let dropDown = DropDown()
    
    //MARK:- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(title: String, date: String, index: Int) {
        self.index = index
        self.titleLabel.text = title
        self.dateLabel.text = date
        dropDown.anchorView = dropDownView
        dropDown.dataSource = dropDownDataSource
        
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)

        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            
            guard let self = self else { return }
         
            self.delegate?.dotMenuTapped(selectedValue: item)
//            self.dropDown.deselectRow(index)
            self.dropDown.deselectRow(at: index)
        }

    }
    
    //MARK:- Actions
    
    @IBAction func dotMenuTapped(_ sender: UIButton) {
        dropDown.show()
    }

}
