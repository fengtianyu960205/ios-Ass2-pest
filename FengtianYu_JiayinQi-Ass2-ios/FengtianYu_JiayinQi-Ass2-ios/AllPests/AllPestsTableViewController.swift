//
//  AllPestsTableViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 1/11/20.
//  Copyright © 2020 Monash University. All rights reserved.
//
import SDWebImage
import UIKit

class AllPestsTableViewController: UITableViewController ,DatabaseListener,UISearchResultsUpdating{
    
    
    
    var allPest: [Pest] = []
    var filteredPests: [Pest] = []
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .all
    var selectedPest : Pest?

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.isHidden = true
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        filteredPests = allPest
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Pests"
        navigationItem.searchController = searchController
        
        // This view controller decides how the search controller is presented
        definesPresentationContext = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            return
        }
        
        if searchText.count > 0 {
            filteredPests = allPest.filter({ (pest: Pest) -> Bool in
                return pest.name.lowercased().contains(searchText) ?? false
            })
        } else {
            filteredPests = allPest
        }
        
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredPests.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pestCell = tableView.dequeueReusableCell(withIdentifier: "PestCell", for: indexPath) as! PestCellTableViewCell

        let pest = filteredPests[indexPath.row]
        
        let verticalPadding: CGFloat = 8

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: pestCell.bounds.origin.x, y: pestCell.bounds.origin.y, width: pestCell.bounds.width, height: pestCell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        pestCell.layer.mask = maskLayer
        
        pestCell.pestCategory.text = pest.category
        //pestCell.pestCategory.textColor = .secondaryLabel
        pestCell.pestName.text = pest.name
       // pestCell.pestName.textColor = .secondaryLabel
        let urlkey = pest.image_url
        let url = URL(string : urlkey)
       // do{
       //     let data = try Data(contentsOf : url!)
       //     pestCell.imageView?.image = UIImage(data : data)
       // }catch let _{
       //     print("error in fetching image")
      //  }
        //pestCell.imageView!.frame = pestCell.frame.offsetBy(dx: 10, dy: 10)
        pestCell.imageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "fox"))
        return pestCell
    }
    
    override func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        // when click the row, it will go to detail information screen
        
        selectedPest = self.filteredPests[indexPath.row]
        performSegue(withIdentifier: "AllPestToDetail", sender: self)
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "AllPestToDetail" {
       let destination = segue.destination as! detailInformationViewController
       destination.showedPest = selectedPest
        destination.hidesBottomBarWhenPushed = true
       }
    }
    
    
    func onPestChange(change: DatabaseChange, pests: [Pest]) {
           allPest = pests
        var a = allPest.count
           updateSearchResults(for: navigationItem.searchController!)
       }

}