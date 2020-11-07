//
//  detailInformationViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 15/10/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

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
            
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView()
        
        pestRegion.text = showedPest?.region
        pestHeight.text = showedPest?.height
        pestWeight.text = showedPest?.weight
        pestName.text = showedPest?.name
        pestCategory.text = showedPest?.category
        let urlkey = showedPest?.image_url
        let url = URL(string : urlkey!)
        pestImage.sd_setImage(with: url, placeholderImage: UIImage(named: "fox"))
        
        
        userPestList = (user!.pestlist?.allObjects as? [PestCD])!
      
        for pest in userPestList{
            if showedPest!.id == pest.pestID {
                flag = false
                pestcd = pest
                 pestListbtn.setImage(UIImage(systemName: "star.fill"), for: .normal)
               break
            }
        }
        
        pestListbtn.addTarget(self, action: #selector(pestListBtn(_:)), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
     func numberOfSections(in tableview: UITableView) -> Int {
        return 5
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
        
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "pestLocationCell",
            for: indexPath) as! PestInformationTableViewCell
            return cell
        }
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            
        if indexPath.section == 0{
            let messagecontent = showedPest?.threat
            displayMessage(title: "Threat", message: messagecontent!)
        }
        else if indexPath.section == 1{
            let messagecontent = showedPest?.aid
           displayMessage(title: "First Aid", message: messagecontent!)
        }
        else if indexPath.section == 2{
            let messagecontent = showedPest?.deal
            displayMessage(title: "Deal with the Pest", message: messagecontent!)
        }
        else if indexPath.section == 3{
            let messagecontent = showedPest?.fact
           displayMessage(title: "Fact about the Pest", message: messagecontent!)
        }
        
        else{
            
            var index = 0
            var size = integer_t((showedPest?.latitude.count)!) as integer_t
            for n in 1...size {
                let lat = Double((showedPest?.latitude[index])!)!
                let lng = Double((showedPest?.longitude[index])!)!
                let location = LocationAnnotation(title: (showedPest?.cities[index])!,
                subtitle: "",
                lat: lat, long: lng)
                locationList.append(location)
               index += 1
            }
            
            performSegue(withIdentifier: "detailtomapview", sender: self)
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
    }
     
     
    @IBAction func pestListBtn(_ sender: Any) {
        
        if flag == true{
        
            (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
            
            if (sender as! UIButton).isSelected {
                pestcd = coreDataDatabaseController?.addPest(name: showedPest!.name, pestID: showedPest!.id! , category : showedPest!.category,pestImage : self.pestImage.image!.pngData()!)
                coreDataDatabaseController?.addPestToUser(pestCD: pestcd!, userCD: user!)
                pestListbtn.setImage(UIImage(systemName: "star.fill"), for: .normal)
                   
            }else{
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
    
    
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
            preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss",
            style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}
