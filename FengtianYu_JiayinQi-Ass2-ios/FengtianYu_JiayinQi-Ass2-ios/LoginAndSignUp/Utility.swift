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
        
        button.layer.cornerRadius = 15.0
        button.tintColor = UIColor.white
    }
    
    //this is the style for the normal button
    static func StyleButtonHollowed(_ button: UIButton){
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.init(red: 15/255, green: 146/255, blue: 124/255, alpha: 1).cgColor
        button.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        
        button.layer.cornerRadius = 15.0
        button.tintColor = UIColor.init(red: 15/255, green: 146/255, blue: 124/255, alpha: 1)
    }
    
    static func StyleTextField(_ textfield: UITextField){
        textfield.borderStyle = .none
        textfield.isUserInteractionEnabled = true
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.init(red: 15/255, green: 146/255, blue: 124/255, alpha: 1).cgColor
        textfield.layer.cornerRadius = 5.0
    }
    
    static func StyleUneditTextField(_ textfield: UITextField){
        textfield.borderStyle = .none
        textfield.isUserInteractionEnabled = false
        textfield.layer.borderWidth = 0
        textfield.layer.borderColor = UIColor.init(red: 15/255, green: 146/255, blue: 124/255, alpha: 0).cgColor
        textfield.layer.cornerRadius = 0
    }
}
