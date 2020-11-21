//
//  pestCollectionViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by heathcliff on 2020/11/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class pestCollectionViewController: UIViewController, DatabaseListener {
    
    
    
    var collectionView : UICollectionView?
    
    var listenerType: ListenerType = .users
    var user : UserCD?
    var pestlist : [PestCD] = []
    var pests : [PestCD] = []
    var invasives : [PestCD] = []
    var plants : [PestCD] = []
    weak var coreDataDatabaseController: coreDataDatabaseProtocol?
    weak var databaseController: DatabaseProtocol?
    var selectedPest : Pest?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        coreDataDatabaseController = appDelegate.coreDataDatabaseController
        
        databaseController = appDelegate.databaseController
       
        pestlist = (user!.pestlist?.allObjects as? [PestCD])!
        
        classify()
        
        
        createCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           coreDataDatabaseController?.addListener(listener: self)
        
       }
       
      
       
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           coreDataDatabaseController?.removeListener(listener: self)
       }
    
    //update the collection view when the view will appear
    func classify() {
        pests = []
        invasives = []
        plants = []
        for pest in pestlist {
            if pest.category == "Pest"{
                pests.append(pest)
            }else if pest.category == "Invasive species"{
                invasives.append(pest)
            }else{
                plants.append(pest)
            }
        }
    }
    
    
    func createCollectionView(){
        //create the layout for collection view, scroll vertically, whole screen, item size()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: view.frame.size.width / 2.15, height: view.frame.size.height / 3.1)
        //layout.itemSize = CGSize(width: view.frame.size.width / 2.15, height: view.frame.size.width / 2.15)
        
        //set the collection view
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(pestCollectionViewCell.nib(), forCellWithReuseIdentifier: pestCollectionViewCell.identifier)
        collectionView?.register(headerCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCollectionReusableView.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .clear
        
        //add collection view to view
        view.addSubview(collectionView!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "collectionToDetail"{
            let destination = segue.destination as! detailInformationViewController
            destination.showedPest  = self.selectedPest
        }
    }
    

    
    func onPestChange(change: DatabaseChange, pests: [Pest]) {
        //
    }
    
    func onUserCDChange(change: DatabaseChange, user: [UserCD]) {
        self.user = user.first
        pestlist = (self.user!.pestlist?.allObjects as? [PestCD])!
        classify()
        collectionView?.reloadData()
    }
}

extension pestCollectionViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let pest = pests[indexPath.row]
            selectedPest =  databaseController?.getPestByID(pest.pestID!)
        }else if indexPath.section == 1 {
            let pest = invasives[indexPath.row]
            selectedPest =  databaseController?.getPestByID(pest.pestID!)
        }else{
            let pest = plants[indexPath.row]
            selectedPest =  databaseController?.getPestByID(pest.pestID!)
        }
        performSegue(withIdentifier: "collectionToDetail", sender: self)
        
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

extension pestCollectionViewController : UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return pests.count
        }else if section == 1 {
            return invasives.count
        }else{
            return plants.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pestCollectionViewCell.identifier, for: indexPath) as! pestCollectionViewCell
        
        if indexPath.section == 0 {
            cell.imageView.image = UIImage(data: pests[indexPath.row].pestImage!)!
        }else if indexPath.section == 1 {
            cell.imageView.image = UIImage(data: invasives[indexPath.row].pestImage!)!
        }else{
            cell.imageView.image = UIImage(data: plants[indexPath.row].pestImage!)!
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCollectionReusableView.identifier, for: indexPath) as! headerCollectionReusableView
        
        if indexPath.section == 0 {
            header.configure("Pest")
        }else if indexPath.section == 1 {
            header.configure("Invasive species")
        }else{
            header.configure("Plants")
        }
        
        
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 30)
    }
    
}

extension pestCollectionViewController: UICollectionViewDelegateFlowLayout{
    
}
