//
//  pestCollectionViewCell.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by heathcliff on 2020/11/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class pestCollectionViewCell: UICollectionViewCell {

    static let identifier = "pestCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    static func nib() -> UINib{
        return UINib(nibName: "pestCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.contentMode = .scaleAspectFit
    }

}
