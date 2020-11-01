//
//  PestCellTableViewCell.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 15/10/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class PestCellTableViewCell: UITableViewCell {

    @IBOutlet weak var pestCategory: UILabel!
    @IBOutlet weak var pestName: UILabel!
    @IBOutlet weak var pestImage: UIImageView!
        //= {
       // let imageView = UIImageView(frame: CGRect(x:0,y:0,width:200,height:200))
       // return imageView
   // }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
