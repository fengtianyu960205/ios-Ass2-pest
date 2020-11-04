//
//  LoginViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by heathcliff on 2020/11/2.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    let button = UIButton(type: .custom)
    var userID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        errorLabel.alpha = 0
        setupView()
        setupPWTextField()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "loginSegue" {
        let destination = segue.destination as! TabBarController
            destination.userID = self.userID
        }
    }
    
    func setupView(){
        Utility.StyleButtonFilled(loginButton)
        Utility.StyleButtonHollowed(signUpButton)
        Utility.StyleTextField(usernameTextField)
        Utility.StyleTextField(pwTextField)
    }
    
    func setupPWTextField(){
        pwTextField.rightViewMode = .unlessEditing
        
        button.setImage(UIImage(named: "closedEye"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 25)
        button.frame = CGRect(x: CGFloat(pwTextField.frame.size.width - 5), y: CGFloat(5), width: CGFloat(5), height: CGFloat(5))
        
        button.addTarget(self, action: #selector(btnPWVisible(_:)), for: .touchUpInside)
        pwTextField.rightView = button
        pwTextField.rightViewMode = .always
        pwTextField.isSecureTextEntry = true
        
    }
    
    @IBAction func btnPWVisible(_ sender: Any){
        (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
        
        if (sender as! UIButton).isSelected {
            self.pwTextField.isSecureTextEntry = false
            button.setImage(UIImage(named: "openEye"), for: .normal)
        }else{
            self.pwTextField.isSecureTextEntry = true
            button.setImage(UIImage(named: "closedEye"), for: .normal)
        }
    }
    
    @IBAction func Login(_ sender: Any) {
        let validateError = validateField()
        
        if validateError != nil {
            //there is an error, show error
            showErrorMessage(validateError!)
        }else{
            // no error, create the user
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pw = pwTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: username, password: pw) { (result, error) in
                if error != nil {
                    self.showErrorMessage(error!.localizedDescription)
                }else{
                    self.userID = result?.user.uid
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            }
            
        }
        
    }
    
    
    func validateField() -> String? {
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || pwTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  {
            return "Fill all the fields"
        }
        
        
        return nil
    }
    
    func showErrorMessage(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}
