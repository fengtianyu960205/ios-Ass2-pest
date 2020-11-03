//
//  SettingViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 3/11/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        // Do any additional setup after loading the view.
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

    
}
