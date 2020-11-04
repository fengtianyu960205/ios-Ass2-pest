//
//  TabBarController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 5/11/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var userID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchVC = self.viewControllers![0] as! SearchViewController //first view controller in the tabbar
        searchVC.userID = userID
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
