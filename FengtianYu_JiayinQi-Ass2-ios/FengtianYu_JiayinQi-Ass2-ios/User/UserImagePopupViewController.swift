//
//  UserImagePopupViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by heathcliff on 2020/11/21.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class UserImagePopupViewController: UIViewController {

    var image : UIImage?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //hide the navigation bar
        self.navigationController?.navigationBar.isHidden = true
        setupView()
    }
    
    //hide the navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupView() {
        //set up the size and constraint for the image view and button
        let initsize = view.frame.size.width - 10
        userImageView.frame = CGRect(x: 5, y: (view.frame.size.height - initsize) / 2, width: initsize, height: initsize)
        userImageView.image = image
        userImageView.contentMode = .scaleAspectFit
        backButton.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        backButton.tintColor = .clear
        backButton.backgroundColor = .clear
        self.view.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.3)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //go back to previous view
    @IBAction func goback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
