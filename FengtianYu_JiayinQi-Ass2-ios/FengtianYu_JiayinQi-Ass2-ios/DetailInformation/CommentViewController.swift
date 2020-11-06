//
//  CommentViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 2/11/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate ,DatabaseListener{
    
    
     
    
    var listenerType: ListenerType = .all
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var writeComBtn: UIButton!
    @IBOutlet weak var pestName: UILabel!
    weak var databaseController: DatabaseProtocol?
    var commentedPest : Pest?
    var pestId : String?
    var comments : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        // change Ui for the comment button
        writeComBtn.contentVerticalAlignment = .fill
        writeComBtn.contentHorizontalAlignment = .fill
        writeComBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        //commentedPest = databaseController?.getPestByID(pestId!)
        //commentedPest = databaseController?.getPestByID(pestId!)
        pestId = commentedPest?.id
        comments = commentedPest?.comments as! [String]
        pestName.text = commentedPest?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        
    }
    
   
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
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
        performSegue(withIdentifier: "commentToWrite", sender: self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentToWrite" {
        let destination = segue.destination as! WriteCommentViewController
            destination.commentedPest = self.commentedPest
        }
    }
    
    func onPestChange(change: DatabaseChange, pests: [Pest]) {
       
        commentedPest = databaseController?.getPestByID(pestId!)
        comments = commentedPest?.comments as! [String]
        tableView.reloadData()
    }
    
    func onUserCDChange(change: DatabaseChange, user: [UserCD]) {
        
    }
    

}
