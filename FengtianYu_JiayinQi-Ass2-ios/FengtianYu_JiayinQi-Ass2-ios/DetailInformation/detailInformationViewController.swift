//
//  detailInformationViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 15/10/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit
import Foundation

class detailInformationViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
   
    @IBOutlet weak var commentBtn: UIBarButtonItem!
    @IBOutlet weak var pestImage: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var harmScoreProgress: UIProgressView!
    @IBOutlet weak var pestRegion: UILabel!
    @IBOutlet weak var pestHeight: UILabel!
    @IBOutlet weak var pestWeight: UILabel!
    @IBOutlet weak var pestCategory: UILabel!
    weak var coreDataDatabaseController: coreDataDatabaseProtocol?
    
    @IBOutlet weak var pestName: UILabel!
    @IBOutlet weak var pestListbtn: UIButton!
    var showedPest : Pest?
    var locationList = [LocationAnnotation]()
    var pestcd : PestCD?
    var user : UserCD?
    var userPestList : [PestCD] = []
    var flag : Bool = true
    
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
        coreDataDatabaseController = appDelegate.coreDataDatabaseController
        user = coreDataDatabaseController?.fetchSpecificUser().first!
            
        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView(){
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView()
        
        pestRegion.text = showedPest?.region
        pestHeight.text = showedPest?.height
        pestWeight.text = showedPest?.weight
        pestName.text = showedPest?.name
        pestCategory.text = showedPest?.category
        let pestScore: Float = Float(showedPest?.harmScore ?? 0) / Float(100)
        let urlkey = showedPest?.image_url
        let url = URL(string : urlkey!)
        pestImage.sd_setImage(with: url, placeholderImage: UIImage(named: "loading"))
        Utility.StyleProgressView(harmScoreProgress)
        setProgressView(progress: pestScore)
        
        
        userPestList = (user!.pestlist?.allObjects as? [PestCD])!
      
        // if the pest is in user interesting pest list, make it fill
        for pest in userPestList{
            if showedPest!.id == pest.pestID {
                flag = false
                pestcd = pest
                pestListbtn.setImage(UIImage(systemName: "star.fill"), for: .normal)
                break
            }
        }
        
        pestListbtn.addTarget(self, action: #selector(pestListBtn(_:)), for: .touchUpInside)
    }
    
     func numberOfSections(in tableview: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "pestThreatCell",
            for: indexPath) as! PestInformationTableViewCell
            return cell
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "pestAidCell",
            for: indexPath) as! PestInformationTableViewCell
            return cell
        }
        else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "pestDealCell",
            for: indexPath) as! PestInformationTableViewCell
            return cell
        }
        else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "pestFactCell",
            for: indexPath) as! PestInformationTableViewCell
            return cell
        }
        
        else if indexPath.section == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "pestLocationCell",
            for: indexPath) as! PestInformationTableViewCell
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "pestAlbumCell",
            for: indexPath) as! PestInformationTableViewCell
            return cell
        }
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            
        if indexPath.section == 0{
            let messagecontent = showedPest?.threat ?? "No information"
            displayMessage(title: "Threat", msg: messagecontent, button: "Dismiss")
        }
        else if indexPath.section == 1{
            let messagecontent = showedPest?.aid ?? "No information"
            displayMessage(title: "Threat", msg: messagecontent, button: "Dismiss")
        }
        else if indexPath.section == 2{
            let messagecontent = showedPest?.deal ?? "No information"
            displayMessage(title: "Threat", msg: messagecontent, button: "Dismiss")
        }
        else if indexPath.section == 3{
            let messagecontent = showedPest?.fact ?? "No information"
            displayMessage(title: "Threat", msg: messagecontent, button: "Dismiss")
        }
        
        else if indexPath.section == 4{
            
            var index = 0
            var size = integer_t((showedPest?.location.count)!) as integer_t
            for n in 1...size {
                let inputString = (showedPest?.location[index])!
                let splits = inputString.components(separatedBy: ",")
                let lng = Double(splits[0])!
                let lat = (splits[1] as NSString).doubleValue
                let location = LocationAnnotation(title: splits[2],
                subtitle: "",
                lat: lat, long: lng)
                locationList.append(location)
               index += 1
            }
            
            performSegue(withIdentifier: "detailtomapview", sender: self)
        }
        else{
            performSegue(withIdentifier: "detailtoPestAlbum", sender: self)
        }
        
    }
    

    
    // MARK: - Navigation

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailtomapview" {
        let destination = segue.destination as! SinglePestLocationMapViewController
            destination.locationList = self.locationList
        }
        if segue.identifier == "detailToComment" {
        let destination = segue.destination as! CommentViewController
            destination.commentedPest = self.showedPest
        }
        if segue.identifier == "detailtoPestAlbum" {
        let destination = segue.destination as! PestAlbumViewController
            destination.pest = self.showedPest
        }
    }
     
     
    @IBAction func pestListBtn(_ sender: Any) {
        
        if flag == true{
        
            (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
            
            // if the button is selected, add it to coredata, and make the button fill
            if (sender as! UIButton).isSelected {
                pestcd = coreDataDatabaseController?.addPest(name: showedPest!.name, pestID: showedPest!.id! , category : showedPest!.category,pestImage : self.pestImage.image!.pngData()!)
                coreDataDatabaseController?.addPestToUser(pestCD: pestcd!, userCD: user!)
                pestListbtn.setImage(UIImage(systemName: "star.fill"), for: .normal)
                   
            }else{
                // if the button is unselected, remove it from coredata, and make the button fill
                coreDataDatabaseController?.removePestFromUser(pestCD: pestcd!, userCD: user!)
                pestListbtn.setImage(UIImage(systemName: "star"), for: .normal)
                  
                }
            
        }else{
            (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
            
            if (sender as! UIButton).isSelected {
                coreDataDatabaseController?.removePestFromUser(pestCD: pestcd!, userCD: user!)
                pestListbtn.setImage(UIImage(systemName: "star"), for: .normal)
                   
            }else{
                pestcd = coreDataDatabaseController?.addPest(name: showedPest!.name, pestID: showedPest!.id! , category : showedPest!.category,pestImage : self.pestImage.image!.pngData()!)
                coreDataDatabaseController?.addPestToUser(pestCD: pestcd!, userCD: user!)
                pestListbtn.setImage(UIImage(systemName: "star.fill"), for: .normal)
                }
        }
    }
    
    @IBAction func gotoCommentBtn(_ sender: Any) {
         performSegue(withIdentifier: "detailToComment", sender: self)
       }
    
    func setProgressView(progress : Float) {
        if progress <= 0.3 && progress > 0 {
            self.harmScoreProgress.setProgress(progress, animated: false)
            self.harmScoreProgress.progressTintColor = UIColor.green

        }else if progress > 0.3 && progress <= 0.6{
            self.harmScoreProgress.setProgress(progress, animated: false)
            self.harmScoreProgress.progressTintColor = UIColor.orange

        }else{
            self.harmScoreProgress.setProgress(progress, animated: false)
            self.harmScoreProgress.progressTintColor = UIColor.red
  
        }
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
            preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss",
            style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayMessage(title: String, msg: String, button: String){
        let popUpViewC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "infoPopUpVC") as! infoPopUpViewController
        self.addChild(popUpViewC)
        popUpViewC.view.frame = self.view.frame
        popUpViewC.updateInformation(title: title, msg: msg, button: button)
        self.view.addSubview(popUpViewC.view)
        popUpViewC.didMove(toParent: self)
        
    }

}
