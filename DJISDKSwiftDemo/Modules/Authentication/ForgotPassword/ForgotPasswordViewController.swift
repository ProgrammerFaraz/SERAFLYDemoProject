//
//  ForgotPasswordViewController.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 8/27/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    //MARK:- Properties
    @IBOutlet weak var emailTextfield: UITextField!
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK:- Actions
    @IBAction func sendInstructionsTapped(_ sender: UIButton) {
        
        if emailTextfield.text == ""{
            Snackbar.show(message: "Please fill all fields", duration: .short)
            return
        }
        if isValidEmail(emailTextfield.text ?? ""){
            UIApplication.startActivityIndicator(with: "Sending Email...")
            
            let param = [
                "email" : emailTextfield.text ?? ""
            ]
            AuthenticationAPIService.shared.resetPassword(params: param) { [weak self] response in
                
                guard let self = self else { return }
                
                switch response{
                case .success(let result):
                    UIApplication.stopActivityIndicator()
                    guard let msg = result.message else {
                        Snackbar.show(message: Constants.errorMessage, duration: .middle)
                        return
                    }
                    Snackbar.show(message: msg, duration: .middle)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // Change `2.0` to the desired number of seconds.
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                case .failure(let error):
                    UIApplication.stopActivityIndicator()
                    Snackbar.show(message: error.localizedDescription, duration: .middle)
                }
            }
        }else {
            Snackbar.show(message: "Enter a valid email", duration: .short)
        }
    }
    
}
