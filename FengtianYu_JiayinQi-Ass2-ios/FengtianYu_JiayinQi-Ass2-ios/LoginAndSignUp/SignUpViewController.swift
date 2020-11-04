//
//  SignUpViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by heathcliff on 2020/11/1.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pw2TextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    let button = UIButton(type: .custom)
    var userID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        
        errorLabel.alpha = 0;
        setupView()
        setupPWTextField()
    }
    
    
    func setupView(){
        Utility.StyleButtonFilled(signUpButton)
        Utility.StyleTextField(usernameTextField)
        Utility.StyleTextField(pwTextField)
        Utility.StyleTextField(pw2TextField)
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
        pw2TextField.isSecureTextEntry = true
        
    }
    
    @IBAction func btnPWVisible(_ sender: Any){
        (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
        
        if (sender as! UIButton).isSelected {
            self.pwTextField.isSecureTextEntry = false
            self.pw2TextField.isSecureTextEntry = false
            button.setImage(UIImage(named: "openEye"), for: .normal)
        }else{
            self.pwTextField.isSecureTextEntry = true
            self.pw2TextField.isSecureTextEntry = true
            button.setImage(UIImage(named: "closedEye"), for: .normal)
        }
    }
    
    
    func isPasswordSecure(_ password: String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[0-9])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "signupAndLoginSegue" {
        let destination = segue.destination as! TabBarController
            destination.userID = self.userID
        }
    }
    
    @IBAction func SignUp(_ sender: Any) {
        //validate the text field
        let validateError = validateField()
        
        if validateError != nil {
            //there is an error, show error
            showErrorMessage(validateError!)
        }else{
            // no error, create the user
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pw = pwTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: username, password: pw) { (result, err) in
                if err != nil {
                    //error occur
                    self.showErrorMessage("Error creating user")
                }else{
                    // store the user information to firebase
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["userName" : username, "uid": result!.user.uid]){(error) in
                        if error != nil{
                            self.showErrorMessage("Error saving user data")
                        }
                    }
                    //transition to next screen
                    self.userID = result!.user.uid
                    self.performSegue(withIdentifier: "signupAndLoginSegue", sender: nil)
                }
            }
            
        }
        
    }
    
    func validateField() -> String? {
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || pwTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || pw2TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Fill all the fields"
        }
        
        if pwTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != pw2TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            return "Comfirm the password"
        }
        
        let password = pwTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !isPasswordSecure(password) {
            return "Password must have characters and digits, length should be longer than 8"
        }
        
        return nil
    }
    
    func showErrorMessage(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
}
