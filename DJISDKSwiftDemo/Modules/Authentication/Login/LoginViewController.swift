//
//  LoginViewController.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 8/27/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK:- Properties
    @IBOutlet weak var emailTextfield : UITextField!
    @IBOutlet weak var passwordTextfield : UITextField!
    @IBOutlet weak var loginBtn : UIButton!
    @IBOutlet weak var loginView : UIView!
    @IBOutlet weak var showHidePasswordButton : UIButton!
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        emailTextfield.text = "test@gmail.com"
        passwordTextfield.text = "1"
        #endif
        setupTextfields()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeViewState()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK:- Setup
    
    func setupTextfields() {
        emailTextfield.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextfield.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        changeViewState()
    }
    
    func changeViewState() {
        loginBtn.isUserInteractionEnabled = fieldsNotEmpty()
        loginView.backgroundColor = fieldsNotEmpty() ? UIColor(named: "AppTealBlue") : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    func fieldsNotEmpty() -> Bool {
        return emailTextfield.text != "" && passwordTextfield.text != ""
    }
    
    //MARK:- Actions
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        
        UIApplication.startActivityIndicator(with: "Logging In...")

        let param = [
            "email" : emailTextfield.text ?? "",
            "password" : passwordTextfield.text ?? ""
        ]
        
        if isValidEmail(emailTextfield.text ?? "") && fieldsNotEmpty(){
            AuthenticationAPIService.shared.loginUser(params: param) { [weak self] response in

                guard let self = self else { return }

                switch response{
                case .success(let result):
                    UIApplication.stopActivityIndicator()
                    if let errorMsg = result.message {
                        Snackbar.show(message: errorMsg, duration: .middle)
                        return
                    }
                    guard let loginData = result.data else {
                        return
                    }
                    UserDefaultsHelper.shared.setName(name: loginData.name ?? "")
                    UserDefaultsHelper.shared.setEmail(email: loginData.email ?? "")
                    UserDefaultsHelper.shared.setUserId(userID: loginData.id ?? 0)
                    Snackbar.show(message: "Login Successfully!", duration: .short)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
                        Bootstrapper.showHome()
                    }
                case .failure(let error):
                    UIApplication.stopActivityIndicator()
                    Snackbar.show(message: error.localizedDescription, duration: .middle)
                }
            }
        }else{
            UIApplication.stopActivityIndicator()
            Snackbar.show(message: "Please fill all fields correctly.", duration: .short)
        }
    }
    
    @IBAction func showHidePasswordTapped(_ sender: UIButton) {
        passwordTextfield.isSecureTextEntry.toggle()
        showHidePasswordButton.setImage(passwordTextfield.isSecureTextEntry ? UIImage(named: "eye") : UIImage(named: "eye_slash"), for: .normal)
    }
    
}

extension LoginViewController : StoryboardInitializable {}
