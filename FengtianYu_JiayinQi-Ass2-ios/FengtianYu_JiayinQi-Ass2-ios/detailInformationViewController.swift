//
//  detailInformationViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 15/10/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class detailInformationViewController: UIViewController {
    
    @IBOutlet weak var pestListbtnFill: UIButton!
    @IBOutlet weak var pestListbtn: UIButton!
    var showedPest : Pest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pestListbtnFill.isHidden = true
        // Do any additional setup after loading the view.
    }
    

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
