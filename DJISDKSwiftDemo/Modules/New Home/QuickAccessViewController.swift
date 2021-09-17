//
//  QuickAccessViewController.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 8/22/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import UIKit

class QuickAccessViewController: UIViewController {

    //MARK:- Properties
    @IBOutlet weak var quickAccessCollectionView: UICollectionView!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    
    var projects : [AllProjectData]?

    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchAllProjects), name: .quickAccessAppeared, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- Setup
    func setup() {
        self.quickAccessCollectionView.registerNib(identifier: CollectionViewCellIdentifiers.quickAccessCell)
        self.quickAccessCollectionView.dataSource = self
        self.quickAccessCollectionView.delegate = self
    }
    
    //MARK:- Network Calls
    
    @objc func fetchAllProjects() {
        
        UIApplication.startActivityIndicator(with: nil)
        HomeAPIService.shared.getAllProjects(userID: "\(1)") { [weak self] response in
            guard let self = self else { return }

            switch response {
            case .success(let projectResponse):
                if let projectData = projectResponse.data{
                    if !(projectData.isEmpty) {
                        self.projects = projectData
                        UIApplication.stopActivityIndicator()
                        self.quickAccessCollectionView.isHidden = false
                        self.noDataFoundLabel.isHidden = true
                        self.quickAccessCollectionView.reloadData()
                    }else {
                        UIApplication.stopActivityIndicator()
                        Snackbar.show(message: Constants.noDataMessage, duration: .short)
                        self.quickAccessCollectionView.isHidden = true
                        self.noDataFoundLabel.isHidden = false
                    }
                }else{
                    UIApplication.stopActivityIndicator()
                    Snackbar.show(message: Constants.noDataMessage, duration: .short)
                    self.quickAccessCollectionView.isHidden = true
                    self.noDataFoundLabel.isHidden = false
                }
            case .failure(let error):
                UIApplication.stopActivityIndicator()
                self.quickAccessCollectionView.isHidden = true
                self.noDataFoundLabel.isHidden = false
                Snackbar.show(message: error.localizedDescription, duration: .middle)
            }
        }
    }
}

extension QuickAccessViewController: StoryboardInitializable {}

extension QuickAccessViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = quickAccessCollectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifiers.quickAccessCell, for: indexPath) as? QuickAccessCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(title: projects?[indexPath.item].name ?? "", distance: projects?[indexPath.item].distance ?? "4 feet away", date: projects?[indexPath.item].created_at ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 225.0
        let padding: CGFloat = 0
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
