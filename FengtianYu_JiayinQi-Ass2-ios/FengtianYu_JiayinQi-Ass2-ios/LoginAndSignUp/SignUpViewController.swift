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

        
        // set up the view, make the error label invisible
        errorLabel.alpha = 0;
        setupView()
        setupPWTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //make the navigation bar visible, user can back to login view
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    func setupView(){
        //make the navigation bar visible, user can back to login view
        self.navigationController?.navigationBar.isHidden = false
        //unify the style of the textfoeld and button
        Utility.StyleButtonFilled(signUpButton)
        Utility.StyleTextField(usernameTextField)
        Utility.StyleTextField(pwTextField)
        Utility.StyleTextField(pw2TextField)
    }
    
    func setupPWTextField(){
        
        //create a button with eye image so that user can choose to show the password or not
        pwTextField.rightViewMode = .unlessEditing
        button.setImage(UIImage(named: "closedEye"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 25)
        button.frame = CGRect(x: CGFloat(pwTextField.frame.size.width - 5), y: CGFloat(5), width: CGFloat(5), height: CGFloat(5))
        //add a function to the button
        button.addTarget(self, action: #selector(btnPWVisible(_:)), for: .touchUpInside)
        pwTextField.rightView = button
        pwTextField.rightViewMode = .always
        pwTextField.isSecureTextEntry = true
        pw2TextField.isSecureTextEntry = true
        
    }
    
    @IBAction func btnPWVisible(_ sender: Any){
        //when button is clicked, reverse attribute
        (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
        
        //check the current attribute, if is selected, show the paaword. Otherwise, hide the password
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
    
    //use the regular expression to check the password
    func isPasswordSecure(_ password: String) -> Bool{
        //pssword shold use numbers, characters and the length is equals or longer than 8
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
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.userId = self.userID
            //destination.userID = self.userID
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
        
        //the text field cannot be blank
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || pwTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || pw2TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Fill all the fields"
        }
        
        //two password user entered should be the same
        if pwTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != pw2TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            return "Comfirm the password"
        }
        
        let password = pwTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //check the password fill the requirement of regular expression
        if !isPasswordSecure(password) {
            return "Password must have characters and digits, length should be longer than 8"
        }
        
        return nil
    }
    
    //if there is an error, make the error label visible and show the error
    func showErrorMessage(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
}
