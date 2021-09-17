//
//  ProjectsViewController.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 8/22/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController {

    @IBOutlet weak var projectsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        // Do any additional setup after loading the view.
    }
    
    func setupTableView() {
        self.projectsTableView.delegate = self
        self.projectsTableView.dataSource = self
    }

    @IBAction func mapButtonTapped() {
        
    }
}

extension ProjectsViewController: StoryboardInitializable {}

extension ProjectsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = projectsTableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.projectsCell, for: indexPath) as? ProjectTableViewCell else { return UITableViewCell() }
        cell.configure(title: "Project Name", date: "9/3/21", index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension ProjectsViewController: ProjectsProtocol {
    
    func dotMenuTapped(selectedValue: String) {
        
    }
}
