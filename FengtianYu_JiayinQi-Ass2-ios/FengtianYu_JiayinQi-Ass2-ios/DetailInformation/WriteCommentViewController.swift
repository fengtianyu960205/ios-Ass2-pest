//
//  WriteCommentViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 2/11/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class WriteCommentViewController: UIViewController {

    
    @IBOutlet weak var writeComment: UITextField!
    var commentedPest : Pest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        writeComment.placeholder = "write your comment here"
        let bottonLine = CALayer()
        bottonLine.frame = CGRect(x:0,y:writeComment.frame.height-2,width: writeComment.frame.width, height : 2)
        bottonLine.backgroundColor = UIColor.init(red: 48/255, green : 173/255, blue : 99/255, alpha: 1).cgColor
        writeComment.borderStyle = .none
        writeComment.layer.addSublayer(bottonLine)

           
          
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveComment(_ sender: Any) {
        var pestId = commentedPest?.id
        
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
