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
    
    private var titles = ["Manual", "Maps & Models", "Vertical", "Photo Report", "Video", "Panorama"]
    private var subTitles = ["Capture photos and video manually", "Best for generating maps and models of your location", "Contact us to enable facade flight, inspection and reporting", "Capture photos of your location and create a report", "Capture high quality video of your location", "Generate a spherical panorama for 360 degree views"]
    private var images = [UIImage(named: "template_manual")!, UIImage(named: "template_mapsmodel")!, UIImage(named: "template_vertical")!, UIImage(named: "template_photoreport")!, UIImage(named: "template_video")!, UIImage(named: "template_panaroma")!]
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewTemplateTableViewCell", for: indexPath) as? NewTemplateTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(image: images[indexPath.row], title: titles[indexPath.row], subTitle: subTitles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
