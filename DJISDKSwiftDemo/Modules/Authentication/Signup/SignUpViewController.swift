//
//  SignUpViewController.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 8/27/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    //MARK:- Properties
    @IBOutlet weak var usernameTextfield : UITextField!
    @IBOutlet weak var emailTextfield : UITextField!
    @IBOutlet weak var passwordTextfield : UITextField!
    @IBOutlet weak var confirmPasswordTextfield : UITextField!
    @IBOutlet weak var signupBtn : UIButton!
    @IBOutlet weak var signupView : UIView!
    @IBOutlet weak var showHidePasswordButton : UIButton!
    @IBOutlet weak var showHideConfirmPasswordButton : UIButton!

    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- Setup
    
    func setupTextfields() {
        usernameTextfield.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        emailTextfield.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextfield.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        confirmPasswordTextfield.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)

    }
    
    @objc func textFieldDidChange(textField: UITextField){
        changeViewState()
    }
    
    func changeViewState() {
        signupBtn.isUserInteractionEnabled = fieldsNotEmpty()
        signupView.backgroundColor = fieldsNotEmpty() ? UIColor(named: "AppTealBlue") : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
        
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func fieldsNotEmpty() -> Bool {
        return usernameTextfield.text != "" && emailTextfield.text != "" && confirmPasswordTextfield.text != "" && passwordTextfield.text != ""
    }

    //MARK:- Actions
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signupBtnTapped(_ sender: UIButton) {
        
        UIApplication.startActivityIndicator(with: "Creating Account...")

        let param = [
            "name" : usernameTextfield.text ?? "",
            "email" : emailTextfield.text ?? "",
            "password" : passwordTextfield.text ?? "",
            "password_confirmation" : confirmPasswordTextfield.text ?? ""
        ]
        
        if isValidEmail(emailTextfield.text ?? "") && fieldsNotEmpty(){
            AuthenticationAPIService.shared.signupUser(params: param) { [weak self] response in
                guard let self = self else { return }
                
                switch response{
                case .success(let result):
                    UIApplication.stopActivityIndicator()
                    if let errorMsg = result.message?.first {
                        Snackbar.show(message: errorMsg, duration: .middle)
                        return
                    }
                    guard let loginData = result.data else {
                        return
                    }
                    UserDefaultsHelper.shared.setName(name: loginData.name ?? "")
                    UserDefaultsHelper.shared.setEmail(email: loginData.email ?? "")
                    UserDefaultsHelper.shared.setUserId(userID: loginData.id ?? 0)
                    Snackbar.show(message: "Signup Successfully!", duration: .middle)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
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
    
    @IBAction func showHideConfirmPasswordTapped(_ sender: UIButton) {
        confirmPasswordTextfield.isSecureTextEntry.toggle()
        showHideConfirmPasswordButton.setImage(confirmPasswordTextfield.isSecureTextEntry ? UIImage(named: "eye") : UIImage(named: "eye_slash"), for: .normal)
    }
}

extension SignUpViewController : StoryboardInitializable {}
