//
//  ViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 13/10/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit
// this class is embeded with three viewcontroller, user can scroll the screen to different viewcontroller
class SearchViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var tabSegmentControl: UISegmentedControl!
    //@IBOutlet weak var nameBtn: UIButton!
    //@IBOutlet weak var stateBtn: UIButton!
    //@IBOutlet weak var cityBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    var first : AllPestsTableViewController?
    var second : CityPestTableViewController?
    var third : StatePestTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Utility.StyleSegmentControl(tabSegmentControl)
        //nameBtn.setTitleColor(.red, for: .normal)
        //cityBtn.setTitleColor(.blue, for: .normal)
        //stateBtn.setTitleColor(.blue, for: .normal)
        scrollView.delegate = self
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.first = storyboard.instantiateViewController(withIdentifier: "A") as! AllPestsTableViewController;

        self.second = storyboard.instantiateViewController(withIdentifier: "B") as! CityPestTableViewController;

        self.third = storyboard.instantiateViewController(withIdentifier: "C") as! StatePestTableViewController;
        
        let viewControllers = [first, second, third]
        
        scrollView.isPagingEnabled = true
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-100)
        scrollView.contentSize = CGSize(width: view.frame.size.width*3, height: scrollView.frame.size.height)
        
        var idx:Int = 0
        for viewController in viewControllers {
            addChild(viewController!);
            viewController!.view.frame = CGRect(x: CGFloat(idx) * view.frame.size.width, y: 0, width: view.frame.size.width, height: scrollView.frame.size.height);
            scrollView!.addSubview(viewController!.view)
            idx += 1;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    

    /*@IBAction func nameBtnAct(_ sender: Any) {
        scrollView.setContentOffset(CGPoint(x: CGFloat(0) * view.frame.size.width, y: 0), animated: true)
    }
    
    @IBAction func citybtnAct(_ sender: Any) {
        scrollView.setContentOffset(CGPoint(x: CGFloat(1) * view.frame.size.width, y: 0), animated: true)
    }
    @IBAction func stateBtnAct(_ sender: Any) {
        scrollView.setContentOffset(CGPoint(x: CGFloat(2) * view.frame.size.width, y: 0), animated: true)
    }
    */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tabSegmentControl.selectedSegmentIndex = Int(floor(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))   
    }
    
    
    @IBAction func tabChanged(_ sender: Any) {
        scrollView.setContentOffset(CGPoint(x: CGFloat(tabSegmentControl.selectedSegmentIndex) * view.frame.size.width, y: 0), animated: true)

    }
}

