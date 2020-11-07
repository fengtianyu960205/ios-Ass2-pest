//
//  SettingViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by heathcliff on 2020/11/6.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        
        setupView()
    }
    
    func setupView(){
        //if a user login
        Utility.StyleButtonEmergency(logOutButton)
        //if no user login
        //Utility.StyleButtonDisable(logOutButton)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableview: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell",
            for: indexPath) as! PestInformationTableViewCell
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell",
            for: indexPath) as! PestInformationTableViewCell
            return cell
        }
        
        
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            
            //currentSelectedPlant = currentPlants[indexPath.row]
            //performSegue(withIdentifier: "gotoDetailPlant", sender: self)
        if indexPath.section == 0{
             performSegue(withIdentifier: "settingToAbout", sender: self)
        }
        if indexPath.section == 1{
             performSegue(withIdentifier: "settingToQuestion", sender: self)
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func logOutAccount(_ sender: Any) {
        //user want to log out
        //diable the user interaction and make it invisible
        Utility.StyleButtonDisable(logOutButton)
        //go back to login view?
        //use a dafault user?
        self.performSegue(withIdentifier: "unwindToViewController", sender: self)
    }
}
