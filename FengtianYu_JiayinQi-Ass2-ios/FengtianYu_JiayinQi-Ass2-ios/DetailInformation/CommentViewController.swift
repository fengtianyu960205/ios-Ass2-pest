//
//  CommentViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 2/11/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var writeComBtn: UIButton!
    @IBOutlet weak var pestName: UILabel!
    
    var commentedPest : Pest?
    
    var comments : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    // change Ui for the comment button
    writeComBtn.contentVerticalAlignment = .fill
    writeComBtn.contentHorizontalAlignment = .fill
    writeComBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        comments = commentedPest?.comments as! [String]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell",for: indexPath)
        cell.textLabel?.text = self.comments[indexPath.row]
        return cell
        
    }
    

    @IBAction func writeComBtnAct(_ sender: Any) {
        
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
