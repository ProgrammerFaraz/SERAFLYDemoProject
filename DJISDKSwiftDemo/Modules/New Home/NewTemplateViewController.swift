//
//  NewTemplateViewController.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 9/21/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import UIKit

class NewTemplateViewController: UIViewController {

    //MARK:- Outlets & Properties
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK:- Actions
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension NewTemplateViewController: StoryboardInitializable {}

extension NewTemplateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
