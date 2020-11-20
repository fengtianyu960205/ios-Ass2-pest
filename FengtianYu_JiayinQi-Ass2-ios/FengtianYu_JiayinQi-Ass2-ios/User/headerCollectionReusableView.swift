//
//  headerCollectionReusableView.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by heathcliff on 2020/11/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class headerCollectionReusableView: UICollectionReusableView {
    static let identifier = "headerCollectionReusableView"
    
    private let label : UILabel = {
        let label = UILabel()
        label.text = "text"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont(name: "MontserratAlternates-Medium", size: 17)!
        return label
    }()
    
    public func configure(_ header : String) {
        backgroundColor = .clear
        label.text = header
        addSubview(label)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
}
