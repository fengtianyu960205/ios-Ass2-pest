//
//  LocationAnnotation.swift
//  Fengtian-Yu-iOSApplication
//
//  Created by 俞冯天 on 9/9/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit
import MapKit

// this class is an annotaion 
class LocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    init(title: String, subtitle: String, lat: Double, long: Double) {
        self.title = title
        self.subtitle = subtitle
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
