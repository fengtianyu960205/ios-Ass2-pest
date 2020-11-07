//
//  Utility.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by heathcliff on 2020/11/4.
//  Copyright © 2020 Monash University. All rights reserved.
//

import Foundation
import UIKit

class Utility{
    
    //this is the style for the important button
    static func StyleButtonFilled(_ button: UIButton){
        button.backgroundColor = UIColor.init(red: 233/255, green: 81/255, blue: 73/255, alpha: 1)
        button.isUserInteractionEnabled = true
        button.isHidden = false
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.init(red: 15/255, green: 146/255, blue: 124/255, alpha: 1).cgColor
        button.layer.cornerRadius = 15.0
        button.tintColor = UIColor.white
    }
    
    //this is the style for the normal button
    static func StyleButtonHollowed(_ button: UIButton){
        button.isUserInteractionEnabled = true
        button.isHidden = false
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.init(red: 15/255, green: 146/255, blue: 124/255, alpha: 1).cgColor
        button.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        
        button.layer.cornerRadius = 15.0
        button.tintColor = UIColor.init(red: 15/255, green: 146/255, blue: 124/255, alpha: 1)
    }
    
    //this is the style for the emergency button
    static func StyleButtonEmergency(_ button: UIButton){
        button.isUserInteractionEnabled = true
        button.isHidden = false
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.init(red: 15/255, green: 146/255, blue: 124/255, alpha: 1).cgColor
        button.backgroundColor = UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        button.layer.cornerRadius = 15.0
        button.tintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    }
    
    //disble the button
    static func StyleButtonDisable(_ button: UIButton){
        
        button.isUserInteractionEnabled = false
        button.isHidden = true
        
    }
    
    static func StyleTextField(_ textfield: UITextField){
        textfield.borderStyle = .none
        textfield.isUserInteractionEnabled = true
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.init(red: 15/255, green: 146/255, blue: 124/255, alpha: 1).cgColor
        textfield.layer.cornerRadius = 5.0
        textfield.clearButtonMode = .whileEditing
    }
    
    static func StyleUneditTextField(_ textfield: UITextField){
        textfield.borderStyle = .none
        textfield.isUserInteractionEnabled = false
        textfield.layer.borderWidth = 0
        textfield.layer.borderColor = UIColor.init(red: 15/255, green: 146/255, blue: 124/255, alpha: 0).cgColor
        textfield.layer.cornerRadius = 0
    }
    
    
    static func StyleSegmentControl(_ segmentControl: UISegmentedControl){
        segmentControl.backgroundColor = .clear
        segmentControl.selectedSegmentTintColor = UIColor.white
        segmentControl.isUserInteractionEnabled = true
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "AvenirNextCondensed-Medium", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "AvenirNextCondensed-Medium", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.init(red: 233/255, green: 81/255, blue: 73/255, alpha: 1)], for: .selected)
        segmentControl.layer.borderColor = UIColor.init(red: 15/255, green: 146/255, blue: 124/255, alpha: 1).cgColor
        segmentControl.layer.borderWidth = 1
    }
    
    static func StyleUneditSegmentControl(_ segmentControl: UISegmentedControl){
        segmentControl.backgroundColor = .clear
        segmentControl.selectedSegmentTintColor = .clear
        segmentControl.isUserInteractionEnabled = false
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "AvenirNextCondensed-Medium", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "AvenirNextCondensed-Medium", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.init(red: 233/255, green: 81/255, blue: 73/255, alpha: 1)], for: .selected)
        segmentControl.layer.borderColor = UIColor.init(red: 15/255, green: 146/255, blue: 124/255, alpha: 1).cgColor
        segmentControl.layer.borderWidth = 0
    }
    
    static func StyleProgressView(_ progressView: UIProgressView){
        progressView.layer.cornerRadius = 7
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 2)
    }
}
