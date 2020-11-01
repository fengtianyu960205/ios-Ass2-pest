//
//  Pest.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 1/11/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class Pest: NSObject,Decodable,Encodable {
    var id : String?
    var name : String = ""
    var category : String = ""
    var image_url : String = ""
    
    enum CodingKeys: String,CodingKey {
        case id
        case name
        case category
        case image_url
    }

}
