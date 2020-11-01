//
//  SignUpViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by heathcliff on 2020/11/1.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pw2TextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        
        errorLabel.alpha = 0;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
                    //transition to next screen
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
        
        return nil
    }
    
    func showErrorMessage(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
}
