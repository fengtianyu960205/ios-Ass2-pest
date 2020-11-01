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
    override func viewDidLoad() {
        super.viewDidLoad()

        errorLabel.alpha = 0
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
