//
//  AddProjectDialogViewController.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 9/17/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import UIKit
import PopupDialog

class AddProjectDialogViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var continueBtn: UIButton!
    var continueCallBack : ((String) -> Void)?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        titleTextField.text = "test"
        #endif
        // Do any additional setup after loading the view.
    }

    @IBAction func continueBtnAction(_ sender: UIButton) {
        if titleTextField.text != "" {
            continueCallBack?(titleTextField.text ?? "")
        }else{
            Snackbar.show(message: "Enter Project Name", duration: .short)
        }
    }
    
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddProjectDialogViewController: StoryboardInitializable {}
