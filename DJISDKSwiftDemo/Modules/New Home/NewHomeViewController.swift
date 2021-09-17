//
//  NewHomeViewController.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 8/22/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import UIKit
import Floaty
import SideMenu

class NewHomeViewController: UIViewController {

    //MARK:- Outlets & Properties
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    let quickAccessVC = QuickAccessViewController.initFromStoryboard(name: "Home")
    let projectsVC = ProjectsViewController.initFromStoryboard(name: "Home")
    let homeStoryboard = UIStoryboard.init(name: "Home", bundle: nil)
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupSideMenu()
        createFloatingButton()
        addQuickAccessView()
        addProjectsView()
        segmentSelected(index: self.segmentControl.selectedSegmentIndex)
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Setup Views
    fileprivate func setupSideMenu() {
        let sideMenu = homeStoryboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        SideMenuManager.default.menuWidth = UIScreen.main.bounds.width * 0.9
        sideMenu?.menuWidth = 400
        SideMenuManager.default.leftMenuNavigationController = sideMenu
    }
    
    func addQuickAccessView() {
        self.parentView.addSubview(quickAccessVC.view)
//        addChild(quickAccessVC)
//        quickAccessVC.didMove(toParent: self)
        addQuickAccessViewConstraints()
    }
    
    func addQuickAccessViewConstraints() {
        quickAccessVC.view.translatesAutoresizingMaskIntoConstraints = false
        quickAccessVC.view.bottomAnchor.constraint(equalTo: self.parentView.bottomAnchor, constant: 0).isActive = true
        quickAccessVC.view.topAnchor.constraint(equalTo: self.parentView.topAnchor, constant: 0).isActive = true
        quickAccessVC.view.leadingAnchor.constraint(equalTo: self.parentView.leadingAnchor, constant: 0).isActive = true
        quickAccessVC.view.trailingAnchor.constraint(equalTo: self.parentView.trailingAnchor, constant: 0).isActive = true
        quickAccessVC.view.heightAnchor.constraint(equalToConstant: self.parentView.frame.height * 0.8).isActive = true
    }
    
    func addProjectsView() {
        self.parentView.addSubview(projectsVC.view)
//        addChild(projectsVC)
//        projectsVC.didMove(toParent: self)
        addProjectsViewConstraints()
    }
    
    func addProjectsViewConstraints() {
        projectsVC.view.translatesAutoresizingMaskIntoConstraints = false
        projectsVC.view.bottomAnchor.constraint(equalTo: self.parentView.bottomAnchor, constant: 0).isActive = true
        projectsVC.view.topAnchor.constraint(equalTo: self.parentView.topAnchor, constant: 0).isActive = true
        projectsVC.view.leadingAnchor.constraint(equalTo: self.parentView.leadingAnchor, constant: 0).isActive = true
        projectsVC.view.trailingAnchor.constraint(equalTo: self.parentView.trailingAnchor, constant: 0).isActive = true
        projectsVC.view.heightAnchor.constraint(equalToConstant: self.parentView.frame.height * 0.8).isActive = true
    }
    
    func segmentSelected(index: Int) {
        print("🔁 Segment Index : \(index)")
        UIView.transition(with: self.quickAccessVC.view, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.quickAccessVC.view.isHidden = index != 0
            NotificationCenter.default.post(name: .quickAccessAppeared, object: nil)
        }, completion: nil)
        UIView.transition(with: self.projectsVC.view, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.projectsVC.view.isHidden = index != 1
        }, completion: nil)
    }
    
    func createFloatingButton() {
        let floaty = Floaty()
        floaty.addItem("New Project", icon: #imageLiteral(resourceName: "plus"), handler: { [weak self] item in //TODO: remove force unwrap on image
            guard let self = self else { return }
            let alert = UIAlertController(title: "New Project", message: "Do you want to add a new project?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] action in
                guard let self = self else { return }
//                let newProjectVC =
            }))
            alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
            floaty.close()
        })
        self.view.addSubview(floaty)
    }
    
    //MARK:- Actions
    
    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
        self.segmentSelected(index: sender.selectedSegmentIndex)
    }
    
    @IBAction func mapButtonTapped(_ sender: UIButton) {
        let vc = RootMapViewController.initFromStoryboard(name: Storyboards.Home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sideMenuTapped(_ sender: UIButton) {
        Utilities.setupSideMenu(fromMap: false, viewController: self)
    }
    
}

extension NewHomeViewController : StoryboardInitializable {}
