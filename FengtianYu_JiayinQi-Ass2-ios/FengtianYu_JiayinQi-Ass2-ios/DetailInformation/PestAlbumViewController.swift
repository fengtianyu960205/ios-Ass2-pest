//
//  PestAlbumViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 20/11/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit
import SDWebImage

class PestAlbumViewController: UIViewController, UIScrollViewDelegate {
    var pest : Pest?
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    weak var databaseController: DatabaseProtocol?
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        pest = databaseController?.getPestByID((pest?.id)!)
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        pageControl.numberOfPages = (pest?.images.count)!
        
        for index in 0..<(pest?.images.count)! {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            let imageView = UIImageView(frame : frame)
            let urlkey = pest?.images[index]
            let url = URL(string : urlkey!)
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "loading"))
            self.scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat((pest?.images.count)!) * scrollView.frame.size.width, height: scrollView.frame.size.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var number = Int(floor(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
        pageControl.currentPage = number
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
