//
//  PestListTableViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 5/11/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class PestListTableViewController: UITableViewController,DatabaseListener {
    
    
    
     var listenerType: ListenerType = .users
    var user : UserCD?
    var pestlist : [PestCD] = []
    weak var coreDataDatabaseController: coreDataDatabaseProtocol?
    weak var databaseController: DatabaseProtocol?
    var selectedPest : Pest?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        coreDataDatabaseController = appDelegate.coreDataDatabaseController
        
        databaseController = appDelegate.databaseController
       
        pestlist = (user!.pestlist?.allObjects as? [PestCD])!
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           coreDataDatabaseController?.addListener(listener: self)
        
       }
       
      
       
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           coreDataDatabaseController?.removeListener(listener: self)
       }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pestlist.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pestCell = tableView.dequeueReusableCell(withIdentifier: "PestListCell", for: indexPath) as! PestCellTableViewCell

          let pest = pestlist[indexPath.row]
          
          let verticalPadding: CGFloat = 8

          let maskLayer = CALayer()
          maskLayer.cornerRadius = 10    //if you want round edges
          maskLayer.backgroundColor = UIColor.black.cgColor
          maskLayer.frame = CGRect(x: pestCell.bounds.origin.x, y: pestCell.bounds.origin.y, width: pestCell.bounds.width, height: pestCell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
          pestCell.layer.mask = maskLayer
          
          pestCell.pestCategory.text = pest.category
          pestCell.pestName.text = pest.name
      
        pestCell.imageView!.image = UIImage(data: (pest.pestImage)!)!
          return pestCell
    }
    
    override func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        
        let pest = pestlist[indexPath.row]
        selectedPest =  databaseController?.getPestByID(pest.pestID!)
        performSegue(withIdentifier: "pestInterestedListToPestDetail", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.coreDataDatabaseController!.removePestFromUser(pestCD: pestlist[indexPath.row], userCD: user!)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pestInterestedListToPestDetail" {
        let destination = segue.destination as! detailInformationViewController
            destination.showedPest = self.selectedPest
        }
    }
    
    func onPestChange(change: DatabaseChange, pests: [Pest]) {
        
    }
    
    func onUserCDChange(change: DatabaseChange, user: [UserCD]) {
        self.user = user.first
        pestlist = (self.user!.pestlist?.allObjects as? [PestCD])!
        tableView.reloadData()
    }
    

}
