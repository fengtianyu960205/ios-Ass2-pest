//
//  SinglePestLocationMapViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 1/11/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class SinglePestLocationMapViewController: UIViewController,MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
   
    
    var locationList = [LocationAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        for pestLocation in locationList{
            
            self.mapView.addAnnotation(pestLocation)
            showCircle(coordinate: pestLocation.coordinate,
            radius: 10000)
        }
    }
    
    func mapView(_ mapView: MKMapView,
                    rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
           // If you want to include other shapes, then this check is needed.
           // If you only want circles, then remove it.
            let circleOverlay = overlay as? MKCircle
        let circleRenderer = MKCircleRenderer(overlay: circleOverlay as! MKOverlay)
               circleRenderer.fillColor = .red
               circleRenderer.alpha = 0.5

               return circleRenderer
           
    }
    
    // Radius is measured in meters
    func showCircle(coordinate: CLLocationCoordinate2D,
                    radius: CLLocationDistance) {
        let circle = MKCircle(center: coordinate,
                              radius: radius)
        mapView.addOverlay(circle)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationList.removeAll()
        
    }
    
    func focusOn(annotation: MKAnnotation) {
        mapView.selectAnnotation(annotation, animated: true)
     let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 20000,longitudinalMeters: 20000)
     mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
     }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var view : MKPinAnnotationView
        if let annotation = annotation as? LocationAnnotation {
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                annotationView.annotation = annotation
                view = annotationView as! MKPinAnnotationView
                return annotationView
            } else {
                let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
                annotationView.isEnabled = true
                annotationView.canShowCallout = true
                
                

                let btn = UIButton(type: .detailDisclosure)
                annotationView.rightCalloutAccessoryView = btn
                return annotationView
            }
        }

        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let annotation = view.annotation as? LocationAnnotation
        focusOn(annotation: annotation as! MKAnnotation)
       
        
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
