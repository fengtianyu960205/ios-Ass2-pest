//
//  UserViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 15/10/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,DatabaseListener {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    var listenerType: ListenerType = .users
    weak var coreDataDatabaseController: coreDataDatabaseProtocol?
    var user : UserCD?
    
    var editable : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        coreDataDatabaseController = appDelegate.coreDataDatabaseController
        
       tableView.delegate = self
       tableView.dataSource = self
       tableView.tableFooterView = UIView()
        userImage?.image = UIImage(named: "manPortrait")
    
        
        setupView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           coreDataDatabaseController?.addListener(listener: self)
        nameTextField.text = self.user!.nickName
       }
       
      
       
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           coreDataDatabaseController?.removeListener(listener: self)
       }
    
    func onUserCDChange(change: DatabaseChange, user: [UserCD]) {
        
        self.user = user.first
        
    }
    
    func setupView(){
        // create a ui button
        let button = UIButton(type: .custom)
        //set image for button
        button.setImage(UIImage(named: "settings"), for: .normal)
        //add function for button
        button.addTarget(self, action: #selector(settingButtonPressed), for: .touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
        
        //set textfield uneditable
        Utility.StyleUneditTextField(nameTextField)
        Utility.StyleUneditTextField(ageTextField)
        Utility.StyleUneditTextField(locationTextField)
        editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        
        //set the segmentedControl
        Utility.StyleUneditSegmentControl(genderSegmentControl)
        
        //initialize the editable flag
        editable = false
    }
    
    @IBAction func settingButtonPressed(_ sender: Any){
           (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
           
           if (sender as! UIButton).isSelected {
               self.performSegue(withIdentifier: "userToSetting", sender: nil)
           }else{
            self.performSegue(withIdentifier: "userToSetting", sender: nil)
        }
       }

    func numberOfSections(in tableview: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            let cell = tableView.dequeueReusableCell(withIdentifier: "pestListCell",
            for: indexPath) as! PestInformationTableViewCell
            return cell
        
        
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            
            //currentSelectedPlant = currentPlants[indexPath.row]
            //performSegue(withIdentifier: "gotoDetailPlant", sender: self)
        if indexPath.section == 0{
             performSegue(withIdentifier: "userToPestList", sender: self)
        }
        
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userToPestList" {
        let destination = segue.destination as! PestListTableViewController
            destination.user = self.user
        }
    }
    
    @IBAction func editProfile(_ sender: Any) {
        editable = !editable
        if editable == false{
            //user finish edit the profile
            Utility.StyleUneditTextField(nameTextField)
            Utility.StyleUneditTextField(ageTextField)
            Utility.StyleUneditTextField(locationTextField)
            //set the segmentedControl
            Utility.StyleUneditSegmentControl(genderSegmentControl)
            editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        }else{
            //user start to editting the profile
            Utility.StyleTextField(nameTextField)
            Utility.StyleTextField(ageTextField)
            Utility.StyleTextField(locationTextField)
            //set the segmentedControl
            Utility.StyleSegmentControl(genderSegmentControl)
            editButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        }
    }
    func onPestChange(change: DatabaseChange, pests: [Pest]) {
        
    }
    
}
