//
//  infoPopUpViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by heathcliff on 2020/11/7.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit



class infoPopUpViewController: UIViewController {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var button1: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        displayPopUp()
    }
    
    func setupView(){
        self.view.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.4)
        Utility.StyleButtonFilled(button1)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func closePopUp(_ sender: Any) {
        finishPopUp()
    }
    
    
    func displayPopUp(){
        self.view.transform = CGAffineTransform(scaleX: 1.3,y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1,y: 1)
        }
    }
    
    func finishPopUp(){
        UIView.animate(withDuration: 0.25) {
            self.view.transform = CGAffineTransform(scaleX: 1.3,y: 1.3)
            self.view.alpha = 0.0
        } completion: { (finished) in
            if finished {
                self.view.removeFromSuperview();
            }
        }

    }
    
    func updateInformation(title: String, msg: String, button: String) {
        self.button1.setTitle(button, for: .normal)
        self.infoTextView.text = msg
        self.titleLable.text = title
    }
    
}
