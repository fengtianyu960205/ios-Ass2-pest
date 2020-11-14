//
//  ViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 13/10/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var nameBtn: UIButton!
    @IBOutlet weak var stateBtn: UIButton!
    @IBOutlet weak var cityBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    var first : AllPestsTableViewController?
    var second : CityPestTableViewController?
    var third : AllPestsTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameBtn.setTitleColor(.red, for: .normal)
        cityBtn.setTitleColor(.blue, for: .normal)
        stateBtn.setTitleColor(.blue, for: .normal)
        scrollView.delegate = self
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.first = storyboard.instantiateViewController(withIdentifier: "A") as! AllPestsTableViewController;

        self.second = storyboard.instantiateViewController(withIdentifier: "B") as! CityPestTableViewController;

        self.third = storyboard.instantiateViewController(withIdentifier: "A") as! AllPestsTableViewController;
        
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
    

    @IBAction func nameBtnAct(_ sender: Any) {
        scrollView.setContentOffset(CGPoint(x: CGFloat(0) * view.frame.size.width, y: 0), animated: true)
    }
    
    @IBAction func citybtnAct(_ sender: Any) {
        scrollView.setContentOffset(CGPoint(x: CGFloat(1) * view.frame.size.width, y: 0), animated: true)
    }
    @IBAction func stateBtnAct(_ sender: Any) {
        scrollView.setContentOffset(CGPoint(x: CGFloat(2) * view.frame.size.width, y: 0), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var number = Int(floor(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
        if number == 0{
            nameBtn.setTitleColor(.red, for: .normal)
            cityBtn.setTitleColor(.blue, for: .normal)
            stateBtn.setTitleColor(.blue, for: .normal)
        }
        else if number == 1{
            cityBtn.setTitleColor(.red, for: .normal)
            nameBtn.setTitleColor(.blue, for: .normal)
            stateBtn.setTitleColor(.blue, for: .normal)
        }
        else{
            stateBtn.setTitleColor(.red, for: .normal)
            nameBtn.setTitleColor(.blue, for: .normal)
            cityBtn.setTitleColor(.blue, for: .normal)
        }
    }
}

