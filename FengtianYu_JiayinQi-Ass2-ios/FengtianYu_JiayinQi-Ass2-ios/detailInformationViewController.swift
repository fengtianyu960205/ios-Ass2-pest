//
//  detailInformationViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 15/10/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class detailInformationViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var pestImage: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var harmScoreProgress: UIProgressView!
    @IBOutlet weak var pestRegion: UILabel!
    @IBOutlet weak var pestHeight: UILabel!
    @IBOutlet weak var pestWeight: UILabel!
    @IBOutlet weak var pestCategory: UILabel!
    
    @IBOutlet weak var pestName: UILabel!
    @IBOutlet weak var pestListbtnFill: UIButton!
    @IBOutlet weak var pestListbtn: UIButton!
    var showedPest : Pest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pestListbtnFill.isHidden = true
        
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
    
    /*
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            tableView.deselectRow(at: indexPath, animated: false)
            currentSelectedPlant = currentPlants[indexPath.row]
            performSegue(withIdentifier: "gotoDetailPlant", sender: self)
        
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }*/
     
     
    @IBAction func pestListBtn(_ sender: Any) {
        pestListbtn.isHidden = true
         pestListbtnFill.isHidden = false
    }
    
    @IBAction func pestListBtnFill(_ sender: Any) {
        pestListbtnFill.isHidden = true
        pestListbtn.isHidden = false
        
    }
}
