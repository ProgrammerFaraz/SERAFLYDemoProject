//
//  SideMenuViewController.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 8/28/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var sideMenuTableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    var fromMap = false
    var images = [#imageLiteral(resourceName: "map_pin2"),#imageLiteral(resourceName: "map_pin"),#imageLiteral(resourceName: "square_dots"),#imageLiteral(resourceName: "help"),#imageLiteral(resourceName: "academy_cap"),#imageLiteral(resourceName: "settings_gear"),#imageLiteral(resourceName: "Group 3")]
    var titles = ["Projects", "Map", "Apps", "Help", "SeraFly Academy", "Preferences", "Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.text = UserDefaultsHelper.shared.getName()
        sideMenuTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
}

extension SideMenuViewController: StoryboardInitializable {}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = sideMenuTableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.sidemenuCell) as? SideMenuTableViewCell else { return UITableViewCell() }
        cell.configure(image: images[indexPath.row], title: titles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            if fromMap{
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: .projectTapped, object: nil)
            }else {
                self.dismiss(animated: true, completion: nil)
            }
        case 1:
            if fromMap {
                self.dismiss(animated: true, completion: nil)
            }else {
                let vc = RootMapViewController.initFromStoryboard(name: Storyboards.Home)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 6:
            UserDefaultsHelper.shared.setName(name: "")
            UserDefaultsHelper.shared.setEmail(email: "")
            UserDefaultsHelper.shared.setUserId(userID: 0)
            self.navigationController?.popToRootViewController(animated: true)
            let loginVC = LoginViewController.initFromStoryboard(name: Storyboards.Authentication)
            self.navigationController?.pushViewController(loginVC, animated: true)
        default: break
        }
    }
    
}
